"""Compare public checkpoint pairs tensor by tensor, without downloading them.

    uv run --with numpy python scripts/weight_diff.py

Safetensors files can be read by HTTP range request, so a few tensors of a
terabyte checkpoint cost a few gigabytes. For each pair this reads the same
named tensors from both revisions and reports the relative Frobenius change
||B - A|| / ||A||, by family, into notes/research/weight-diffs-2026-11-06.json.

Revisions are pinned. Only formats that decode to a real value are compared:
BF16, F32, and F8_E4M3 with an F8_E8M0 block scale. 4-bit expert tensors sit on
a coarse grid, so their relative change is not comparable and they are skipped.

A value-level diff says where two stored checkpoints differ. It does not say
what the difference does, and two endpoints need not be one run's movement.
"""

import json
import pathlib
import re
import struct
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor

import numpy as np

ROOT = pathlib.Path(__file__).resolve().parents[1]
OUT = ROOT / "notes/research/weight-diffs-2026-11-06.json"

PAIRS = {
    "GLM-5.2 to GLM-5.3": {
        "a": ("zai-org/GLM-5.2", "cf457fa734ab149ffef225f80893eb38c6ff5cdc"),
        "b": ("zai-org/GLM-5.3-BF16", "abf42e6c0e53bc29a875511301e7b7fcd220315b"),
        "layers": (5, 40),
        "last_layer": 77,
        "indexer_layers": (0, 8, 40, 50, 70),
        "families": {
            "attention": r"self_attn\.(q_a_proj|q_b_proj|kv_a_proj_with_mqa|kv_b_proj|o_proj)\.weight$",
            "shared expert": r"mlp\.shared_experts\.\w+\.weight$",
            "router": r"mlp\.gate\.weight$",
            "norm": r"(input_layernorm|post_attention_layernorm)\.weight$",
        },
        "indexer": r"self_attn\.indexer\.(wk|wq_b|weights_proj)\.weight$",
        "globals": {"embedding": r"^model\.embed_tokens\.weight$", "head": r"^lm_head\.weight$"},
    },
    "V4.1-Flash to V4.1-Flash-1017": {
        "a": ("deepseek-ai/DeepSeek-V4.1-Flash", "314113f8a7dadb388215396ba5fbee2c610a04d6"),
        "b": ("deepseek-ai/DeepSeek-V4.1-Flash-1017", "1bae0e1088993b9b82de08f59de5be5a34e42170"),
        "layers": (10, 30),
        "last_layer": 39,
        "indexer_layers": (8, 20, 24, 36),
        "families": {
            "attention": r"attn\.(wq_a|wq_b|wkv|wo_a|wo_b)\.weight$",
            "shared expert": r"ffn\.shared_experts\.w[123]\.weight$",
            "router": r"ffn\.gate\.weight$",
            "norm": r"(attn_norm|ffn_norm)\.weight$",
        },
        "indexer": r"attn\.indexer\.(wk|wq_b|weights_proj)\.weight$",
        "globals": {"embedding": r"^embed\.weight$", "head": r"^head\.weight$"},
    },
    "K3 to K3.1 Pro": {
        "a": ("moonshotai/Kimi-K3", "f831ab66814297da540d832a5235f8e904f29d06"),
        "b": ("moonshotai/Kimi-K3.1-Pro", "d9e99b0792a5e93b78ea9bea62a68167e36ddd9e"),
        "layers": (5, 47),
        "last_layer": 92,
        "indexer_layers": (),
        "families": {
            "attention": r"self_attn\.(q_proj|k_proj|v_proj|o_proj|g_proj|q_a_proj|q_b_proj|kv_a_proj_with_mqa|kv_b_proj)\.weight$",
            "shared expert": r"block_sparse_moe\.shared_experts\.\w+\.weight$",
            "router": r"block_sparse_moe\.gate\.weight$",
            "norm": r"(input_layernorm|post_attention_layernorm)\.weight$",
            "residual norm": r"(self_attention_res_norm|mlp_res_norm)\.weight$",
        },
        "indexer": None,
        "globals": {
            "embedding": r"^language_model\.model\.embed_tokens\.weight$",
            "head": r"^language_model\.lm_head\.weight$",
        },
    },
    "MiMo Pro-RL to Pro-MOPD": {
        "a": ("XiaomiMiMo/MiMo-V2.6-Pro-RL", "a066ba0057192126bd5d255f37138265fc1a435e"),
        "b": ("XiaomiMiMo/MiMo-V2.6-Pro-MOPD", "da71ee15e76a8849bd1a9610195c452007a79678"),
        "layers": (5, 40),
        "last_layer": 69,
        "indexer_layers": (),
        "families": {
            "attention": r"self_attn\.o_proj\.weight$",
            "router": r"mlp\.gate\.weight$",
            "norm": r"(input_layernorm|post_attention_layernorm)\.weight$",
        },
        "indexer": None,
        "globals": {"embedding": r"^model\.embed_tokens\.weight$", "head": r"^lm_head\.weight$"},
    },
}


def fetch(url, start=None, end=None):
    headers = {"User-Agent": "lukstafi-github-io-weight-diff"}
    if start is not None:
        headers["Range"] = f"bytes={start}-{end}"
    request = urllib.request.Request(url, headers=headers)
    error = None
    for attempt in range(6):
        try:
            with urllib.request.urlopen(request, timeout=180) as reply:
                return reply.read()
        except Exception as exc:  # network retries only; the final error is raised
            error = exc
            time.sleep(2 + 3 * attempt)
    raise error


class Checkpoint:
    def __init__(self, repo, revision):
        self.base = f"https://huggingface.co/{repo}/resolve/{revision}/"
        index = json.loads(fetch(self.base + "model.safetensors.index.json"))
        self.weight_map = index["weight_map"]
        self.headers = {}

    def header(self, filename):
        if filename not in self.headers:
            size = struct.unpack("<Q", fetch(self.base + filename, 0, 7))[0]
            self.headers[filename] = (size, json.loads(fetch(self.base + filename, 8, 7 + size)))
        return self.headers[filename]

    def raw(self, name):
        filename = self.weight_map[name]
        size, header = self.header(filename)
        entry = header[name]
        start, end = entry["data_offsets"]
        return entry["dtype"], entry["shape"], fetch(self.base + filename, 8 + size + start, 7 + size + end)

    def read(self, name):
        """Return (decoded array or None, stored dtype, raw bytes)."""
        dtype, shape, data = self.raw(name)
        if dtype == "BF16":
            bits = np.frombuffer(data, np.uint16).astype(np.uint32) << 16
            return bits.view(np.float32).astype(np.float64).reshape(shape), dtype, data
        if dtype == "F32":
            return np.frombuffer(data, np.float32).astype(np.float64).reshape(shape), dtype, data
        if dtype == "F8_E4M3":
            values = FP8_TABLE[np.frombuffer(data, np.uint8)].reshape(shape)
            scale_name = name[: -len("weight")] + "scale"
            if scale_name not in self.weight_map:
                return None, dtype, data
            _, scale_shape, scale_data = self.raw(scale_name)
            exponents = np.frombuffer(scale_data, np.uint8).astype(np.float64).reshape(scale_shape)
            scale = 2.0 ** (exponents - 127)
            block = [s // t for s, t in zip(shape, scale_shape)]
            return values * np.repeat(np.repeat(scale, block[0], axis=0), block[1], axis=1), dtype, data
        return None, dtype, data


def fp8_e4m3(byte):
    """OCP FP8 E4M3: 1 sign, 4 exponent (bias 7), 3 mantissa bits; no infinities."""
    sign = -1.0 if byte & 0x80 else 1.0
    exponent = (byte >> 3) & 0xF
    mantissa = byte & 0x7
    if exponent == 0xF and mantissa == 0x7:
        return float("nan")
    if exponent == 0:
        return sign * mantissa / 8 * 2.0**-6
    return sign * (1 + mantissa / 8) * 2.0 ** (exponent - 7)


FP8_TABLE = np.array([fp8_e4m3(b) for b in range(256)])


def compare(a, b, name):
    x, dtype_a, bytes_a = a.read(name)
    y, dtype_b, bytes_b = b.read(name)
    row = {"name": name, "dtype": [dtype_a, dtype_b], "byte_identical": bytes_a == bytes_b}
    if x is None or y is None or x.shape != y.shape:
        return row
    x, y = x.ravel(), y.ravel()
    good = np.isfinite(x) & np.isfinite(y)
    x, y = x[good], y[good]
    row["relative_change"] = float(np.linalg.norm(y - x) / np.linalg.norm(x))
    row["cosine"] = float(x @ y / (np.linalg.norm(x) * np.linalg.norm(y)))
    return row


def layer_tensors(names, layers, pattern):
    regex = re.compile(pattern)
    wanted = {f"layers.{layer}." for layer in layers}
    selected = []
    for name in names:
        match = re.search(r"layers\.\d+\.", name)
        if match and match.group(0) in wanted and regex.search(name) and not re.search("vision|audio|mtp", name):
            selected.append(name)
    return selected


def main():
    results = {}
    for label, pair in PAIRS.items():
        a = Checkpoint(*pair["a"])
        b = Checkpoint(*pair["b"])
        shared = sorted(set(a.weight_map) & set(b.weight_map))
        added = sorted(set(b.weight_map) - set(a.weight_map))
        removed = sorted(set(a.weight_map) - set(b.weight_map))
        plan = {}
        for family, pattern in pair["families"].items():
            plan[family] = layer_tensors(shared, pair["layers"], pattern)
        for family in ("attention", "shared expert"):
            if family in pair["families"]:
                plan[family + ", last layer"] = layer_tensors(shared, (pair["last_layer"],), pair["families"][family])
        if pair["indexer"]:
            plan["selector"] = layer_tensors(shared, pair["indexer_layers"], pair["indexer"])
        for family, pattern in pair["globals"].items():
            plan[family] = [name for name in shared if re.search(pattern, name)]

        def task(item):
            family, name = item
            return family, compare(a, b, name)

        items = [(family, name) for family, names in plan.items() for name in names]
        # One read per tensor at a time keeps the header cache simple; threads only overlap the transfers.
        for family, name in items[:1]:
            a.header(a.weight_map[name])
        with ThreadPoolExecutor(max_workers=4) as pool:
            rows = list(pool.map(task, items))

        families = {}
        for family, row in rows:
            families.setdefault(family, []).append(row)
        summary = {}
        print(f"\n{label}: {len(shared)} shared tensors, {len(added)} added, {len(removed)} removed", flush=True)
        for family, members in families.items():
            changes = [m["relative_change"] for m in members if "relative_change" in m]
            summary[family] = {
                "tensors": len(members),
                "byte_identical": sum(m["byte_identical"] for m in members),
                "min": min(changes) if changes else None,
                "median": float(np.median(changes)) if changes else None,
                "max": max(changes) if changes else None,
                "formats": sorted({f for m in members for f in m["dtype"]}),
            }
            s = summary[family]
            if changes:
                print(
                    f"  {family:26s} n={s['tensors']:3d} identical={s['byte_identical']:3d} "
                    f"{s['min']:.4f} / {s['median']:.4f} / {s['max']:.4f}  {s['formats']}",
                    flush=True,
                )
            else:
                print(f"  {family:26s} n={s['tensors']:3d} identical={s['byte_identical']:3d}  not decoded {s['formats']}")
        results[label] = {
            "a": list(pair["a"]),
            "b": list(pair["b"]),
            "tensors_added": len(added),
            "tensors_removed": len(removed),
            "families": summary,
            "tensors": [dict(row, family=family) for family, row in rows],
        }
        OUT.write_text(json.dumps(results, indent=1) + "\n")
    print("wrote", OUT)


if __name__ == "__main__":
    sys.exit(main())
