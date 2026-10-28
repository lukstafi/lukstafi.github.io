"""Figures for notes/every-layer-a-store.md.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/every_layer_a_store.py

Figure 3's layer strips are read from each checkpoint's config.json at the
revision pinned in notes/research/frontier-model-sources.json. Downloaded
configs are cached in ~/.cache/every-layer-a-store (override with --cache).
"""

import argparse
import json
import pathlib
import urllib.request

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Rectangle  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
MANIFEST = ROOT / "notes/research/frontier-model-sources.json"
OUT = ROOT / "notes/images"

BG = "#fffff8"
INK = "#2b2b2b"
SLATE = "#53616c"
LIGHT = "#e8eef2"
TEAL = "#258983"
ORANGE = "#c97537"
GREY = "#b0b0b0"

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 10,
    "svg.fonttype": "none",
    "figure.facecolor": BG,
    "axes.facecolor": BG,
    "savefig.facecolor": BG,
})

# Token-mixer kinds in Figure 3.
KINDS = {
    "full": ("full attention", SLATE),
    "window": ("window only", "#d3dae0"),
    "recurrent": ("delta-rule recurrent", TEAL),
    "sparse": ("selected entries", ORANGE),
    "csa": ("compressed, then selected", "#e6b98f"),
    "hca": ("compressed ×128, read in full", "#8e6c8a"),
}


def bare_axes(fig, rect=(0, 0, 1, 1)):
    ax = fig.add_axes(rect)
    ax.set_axis_off()
    return ax


def box(ax, x, y, w, h, text, fc=LIGHT, ec=SLATE, fontsize=10, color=INK, weight="normal"):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0,rounding_size=0.08",
                                fc=fc, ec=ec, lw=1.2))
    ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=fontsize,
            color=color, weight=weight)


def arrow(ax, x0, y0, x1, y1, color=SLATE, lw=1.2, style="-|>"):
    ax.add_patch(FancyArrowPatch((x0, y0), (x1, y1), arrowstyle=style, mutation_scale=10,
                                 color=color, lw=lw, shrinkA=0, shrinkB=0))


# ---------------------------------------------------------------- Figure 1

def figure_block():
    fig = plt.figure(figsize=(10, 5.6))
    ax = bare_axes(fig)
    ax.set_xlim(0, 10)
    ax.set_ylim(0.0, 6.25)

    rx = 1.6  # the residual line
    ax.plot([rx, rx], [0.35, 5.85], color=TEAL, lw=3, solid_capstyle="butt", zorder=1)
    arrow(ax, rx, 5.6, rx, 5.95, color=TEAL, lw=3)
    ax.text(rx, 0.15, "incoming representation", ha="center", va="center", fontsize=10)
    ax.text(rx, 6.08, "outgoing representation", ha="center", va="center", fontsize=10)

    def sublayer(y, label, slot_color):
        # branch out of the residual, normalize, mix, add back
        ax.plot([rx, 2.3], [y - 0.75, y - 0.75], color=SLATE, lw=1.2)
        box(ax, 2.3, y - 0.98, 1.1, 0.46, "normalize", fc=BG, fontsize=9)
        arrow(ax, 3.4, y - 0.75, 3.75, y - 0.75)
        box(ax, 3.75, y - 1.05, 1.9, 0.6, label, fc=slot_color, ec=slot_color,
            color="white", weight="bold")
        ax.plot([5.65, 5.95, 5.95], [y - 0.75, y - 0.75, y], color=SLATE, lw=1.2)
        arrow(ax, 5.95, y, rx + 0.17, y)
        ax.add_patch(plt.Circle((rx, y), 0.17, fc=BG, ec=SLATE, lw=1.2, zorder=3))
        ax.text(rx, y, "+", ha="center", va="center", fontsize=12, zorder=4)

    sublayer(2.55, "mix tokens", ORANGE)
    sublayer(5.0, "mix channels", SLATE)

    notes = [
        (1.8, ORANGE, "Token mixer",
         "full attention · a rolling window · selected entries\n"
         "· compressed entries · a recurrent state"),
        (4.25, SLATE, "Channel mixer",
         "a feed-forward network · a mixture of experts\n"
         "· a table looked up by hashed tokens (Engram)"),
    ]
    for y, c, head, body in notes:
        ax.text(6.35, y + 0.22, head, fontsize=10.5, weight="bold", color=c, va="bottom")
        ax.text(6.35, y + 0.15, body, fontsize=9.5, va="top", color=INK, linespacing=1.5)

    ax.text(0.15, 3.25, "Residual\ncombination", fontsize=10.5, weight="bold", color=TEAL,
            va="center", linespacing=1.3)
    ax.text(0.15, 2.9, "a plain sum\n· mixed streams\n  (mHC)\n· attention over\n"
            "  depth (AttnRes)", fontsize=9.5, va="top", linespacing=1.5)
    return fig


# ---------------------------------------------------------------- Figure 2

def figure_memories():
    n = 16  # past tokens drawn
    fig = plt.figure(figsize=(10, 6.6))
    ax = bare_axes(fig)
    ax.set_xlim(-5.0, 24.6)
    ax.set_ylim(-1.2, 15.3)

    kept_fc = "#c9d3da"
    rows = [
        ("Full history", "keeps every entry\nreads all of them"),
        ("Rolling window", "keeps the most recent\nreads all it keeps"),
        ("Selected entries", "keeps every entry\nscores all, reads a few"),
        ("Compressed entries", "keeps one entry per group\nreads all it keeps"),
        ("Recurrent state", "keeps a fixed-size matrix\nreads the matrix"),
    ]
    ys = [12.6, 9.6, 6.6, 3.6, 0.6]

    def token(x, y, kept=True, w=0.8):
        ax.add_patch(Rectangle((x, y), w, 0.9, fc=kept_fc if kept else BG,
                               ec=SLATE if kept else GREY, lw=1, ls="-" if kept else (0, (2, 2))))

    def read_bar(x0, x1, y, color=ORANGE, lw=4):
        ax.plot([x0, x1], [y - 0.32, y - 0.32], color=color, lw=lw, solid_capstyle="butt")

    def new_token(y):
        ax.add_patch(Rectangle((17.2, y), 0.8, 0.9, fc=ORANGE, ec=ORANGE))
        if y == ys[0]:
            ax.text(17.6, y + 1.3, "new\ntoken", ha="center", va="bottom", fontsize=8.5,
                    color=ORANGE, linespacing=1.1)

    for (name, note), y in zip(rows, ys):
        ax.text(-4.9, y + 0.45, name, fontsize=10.5, weight="bold", va="center")
        ax.text(18.6, y + 0.45, note, fontsize=9, va="center", linespacing=1.4)
        new_token(y)

    # full history
    y = ys[0]
    for i in range(n):
        token(i, y)
    read_bar(0, n - 0.2, y)

    # rolling window
    y = ys[1]
    for i in range(n):
        token(i, y, kept=i >= n - 4)
    read_bar(n - 4, n - 0.2, y)

    # selected entries: an indexer scores all, attention reads a few blocks
    y = ys[2]
    for i in range(n):
        token(i, y)
    read_bar(0, n - 0.2, y, color=GREY, lw=1.5)
    for b in (0, 6, 14):  # the first block, one chosen in the middle, the local block
        read_bar(b, b + 1.8, y)

    # compressed entries: groups of four pooled into one entry
    y = ys[3]
    for g in range(4):
        ax.add_patch(Rectangle((4 * g, y), 3.8, 0.9, fc=kept_fc, ec=SLATE, lw=1))
        for k in range(1, 4):
            ax.plot([4 * g + k, 4 * g + k], [y + 0.15, y + 0.75], color=GREY, lw=0.8)
    read_bar(0, n - 0.2, y)

    # recurrent state: every token writes into one matrix and keeps nothing of its own
    y = ys[4]
    for i in range(n - 3):
        token(i * 0.92, y, kept=False, w=0.72)
    sx = 13.0
    ax.add_patch(Rectangle((sx, y - 0.25), 2.9, 1.4, fc=TEAL, ec=TEAL))
    for k in range(1, 4):
        ax.plot([sx + 0.725 * k] * 2, [y - 0.25, y + 1.15], color=BG, lw=0.6)
        ax.plot([sx, sx + 2.9], [y - 0.25 + 0.35 * k] * 2, color=BG, lw=0.6)
    ax.text(sx + 1.45, y + 1.35, "state", ha="center", va="bottom", fontsize=8.5, color=TEAL)
    arrow(ax, 11.8, y + 0.45, sx - 0.05, y + 0.45, color=TEAL)
    ax.text(5.5, y + 1.3, "each token writes a correction, then is dropped", ha="center",
            va="bottom", fontsize=8.5, color=TEAL)
    read_bar(sx, sx + 2.9, y - 0.03)

    # legend
    ly = -1.0
    ax.add_patch(Rectangle((0, ly), 0.8, 0.5, fc=kept_fc, ec=SLATE, lw=1))
    ax.text(1.0, ly + 0.25, "kept", va="center", fontsize=9)
    ax.add_patch(Rectangle((2.6, ly), 0.8, 0.5, fc=BG, ec=GREY, lw=1, ls=(0, (2, 2))))
    ax.text(3.6, ly + 0.25, "not kept", va="center", fontsize=9)
    ax.plot([5.8, 6.8], [ly + 0.25] * 2, color=ORANGE, lw=4, solid_capstyle="butt")
    ax.text(7.0, ly + 0.25, "read by the new token", va="center", fontsize=9)
    ax.plot([12.6, 13.6], [ly + 0.25] * 2, color=GREY, lw=1.5)
    ax.text(13.8, ly + 0.25, "scored by an indexer", va="center", fontsize=9)
    return fig


# ---------------------------------------------------------------- Figure 3

def fetch_configs(cache):
    cache.mkdir(parents=True, exist_ok=True)
    pins = {c["repo"]: c["sha"] for c in json.loads(MANIFEST.read_text())["checkpoints"]}
    configs = {}
    for repo, sha in pins.items():
        path = cache / f"{repo.replace('/', '_')}-{sha[:12]}.json"
        if not path.exists():
            url = f"https://huggingface.co/{repo}/raw/{sha}/config.json"
            with urllib.request.urlopen(url) as r:
                path.write_bytes(r.read())
        cfg = json.loads(path.read_text())
        configs[repo] = cfg.get("text_config", cfg)
    return configs


def layer_schedules(cfg):
    """One row per model: (name, kinds, dense FFN layers, marks, residual, gap)."""
    rows = []

    c = cfg["XiaomiMiMo/MiMo-V2.6-Pro-RL"]
    kinds = ["full" if p == 0 else "window" for p in c["hybrid_layer_pattern"]]
    dense = [i for i, m in enumerate(c["moe_layer_freq"]) if m == 0]
    rows.append(("MiMo-V2.6-Pro", kinds, dense, {}, "sum", None))

    c = cfg["moonshotai/Kimi-K3"]
    full = {i - 1 for i in c["linear_attn_config"]["full_attn_layers"]}  # one-based
    kinds = ["full" if i in full else "recurrent" for i in range(c["num_hidden_layers"])]
    dense = list(range(c["first_k_dense_replace"]))
    rows.append(("Kimi K3", kinds, dense, {}, f"AttnRes, groups of {c['attn_res_block_size']}", None))

    c = cfg["Qwen/Qwen3.8-2.4T-A95B"]
    kinds = ["full" if t == "full_attention" else "recurrent" for t in c["layer_types"]]
    rows.append(("Qwen3.8", kinds, [], {}, "sum", None))

    c = cfg["zai-org/GLM-5.3"]
    kinds = ["sparse"] * c["num_hidden_layers"]
    dense = [i for i, t in enumerate(c["mlp_layer_types"]) if t == "dense"]
    rows.append(("GLM-5.3", kinds, dense, {}, "sum", None))

    c = cfg["deepseek-ai/DeepSeek-V4-Pro"]
    ratios = c["compress_ratios"][: c["num_hidden_layers"]]
    kinds = ["hca" if r == 128 else "csa" for r in ratios]
    hashed = list(range(c["num_hash_layers"]))
    rows.append(("DeepSeek-V4-Pro", kinds, [], {"hash": hashed}, "mHC, 4 streams", None))

    c = cfg["deepseek-ai/DeepSeek-V4.1-Flash"]
    n = c["num_hidden_layers"]
    ratios = c["compress_ratios"][:n]
    kinds = ["window" if r == 0 else "csa" if r > 1 else "sparse" for r in ratios]
    rows.append(("DeepSeek-V4.1-Flash", kinds, [], {"engram": c["engram_layer_ids"]},
                 "Single-Pass mHC", n // 2))

    c = cfg["MiniMaxAI/MiniMax-M3"]
    dense = [i for i, m in enumerate(c["moe_layer_freq"]) if m == 0]
    kinds = ["sparse" if f else "full" for f in c["sparse_attention_config"]["sparse_attention_freq"]]
    rows.append(("MiniMax-M3", kinds, dense, {}, "sum", None))
    return rows


def figure_layers(cache):
    rows = layer_schedules(fetch_configs(cache))
    fig = plt.figure(figsize=(10, 6.4))
    ax = bare_axes(fig)
    gap_w = 1.5
    ax.set_xlim(-30, 126)
    ax.set_ylim(-5.6, len(rows) * 3 + 1.4)

    for r, (name, kinds, dense, marks, residual, gap) in enumerate(rows):
        y = (len(rows) - 1 - r) * 3
        ax.text(-1.5, y + 0.6, name, ha="right", va="center", fontsize=10, weight="bold")
        for i, k in enumerate(kinds):
            x = i + (gap_w if gap is not None and i >= gap else 0)
            ax.add_patch(Rectangle((x, y), 0.92, 1.2, fc=KINDS[k][1], ec="none"))
            if i in dense:
                ax.add_patch(Rectangle((x, y - 0.55), 0.92, 0.35, fc=INK, ec="none"))
            if i in marks.get("hash", ()):
                ax.add_patch(Rectangle((x, y - 0.55), 0.92, 0.35, fc=BG, ec=INK, lw=0.8))
            if i in marks.get("engram", ()):
                ax.plot(x + 0.46, y + 1.65, marker="D", ms=4.5, color=INK)
        end = len(kinds) + (gap_w if gap is not None else 0)
        ax.text(end + 1.2, y + 0.6, f"{len(kinds)} layers", va="center", fontsize=8.5,
                color=SLATE)
        ax.text(105, y + 0.6, residual, va="center", fontsize=8.5, color=TEAL)
        if gap is not None:
            ax.text(gap / 2, y - 0.25, "encoder", ha="center", va="top", fontsize=8,
                    color=SLATE)
            ax.text(gap + gap_w + (len(kinds) - gap) / 2, y - 0.25, "decoder", ha="center",
                    va="top", fontsize=8, color=SLATE)

    top = len(rows) * 3 - 0.6
    ax.text(105, top, "residual", fontsize=9, weight="bold", color=TEAL, va="bottom")
    for x in (0, 20, 40, 60, 80):
        ax.text(x, top, str(x), ha="left", fontsize=8, color=SLATE, va="bottom")
    ax.text(-1.5, top, "layer", ha="right", fontsize=8, color=SLATE, va="bottom")

    # legend: a grid of three columns
    items = [("patch", color, label) for label, color in KINDS.values()]
    items += [("dense", INK, "dense feed-forward layer (the rest use experts)"),
              ("hash", INK, "experts chosen by a hash of the token"),
              ("engram", INK, "Engram lookup")]
    for j, (kind, color, label) in enumerate(items):
        lx, ly = -28 + 50 * (j % 3), -2.4 - 1.5 * (j // 3)
        if kind == "patch":
            ax.add_patch(Rectangle((lx, ly), 2.2, 1.0, fc=color, ec="none"))
        elif kind == "dense":
            ax.add_patch(Rectangle((lx, ly + 0.3), 2.2, 0.4, fc=INK, ec="none"))
        elif kind == "hash":
            ax.add_patch(Rectangle((lx, ly + 0.3), 2.2, 0.4, fc=BG, ec=INK, lw=0.8))
        else:
            ax.plot(lx + 1.1, ly + 0.5, marker="D", ms=4.5, color=INK)
        ax.text(lx + 3.0, ly + 0.5, label, va="center", fontsize=8.5)
    return fig


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache", type=pathlib.Path,
                    default=pathlib.Path.home() / ".cache/every-layer-a-store")
    args = ap.parse_args()
    OUT.mkdir(exist_ok=True)
    for name, fig in [
        ("every-layer-a-store-block", figure_block()),
        ("every-layer-a-store-memories", figure_memories()),
        ("every-layer-a-store-layers", figure_layers(args.cache)),
    ]:
        fig.savefig(OUT / f"{name}.svg", metadata={"Date": None})
        fig.savefig(pathlib.Path(args.cache) / f"{name}.png", dpi=110)
        plt.close(fig)
        print("wrote", OUT / f"{name}.svg")


if __name__ == "__main__":
    main()
