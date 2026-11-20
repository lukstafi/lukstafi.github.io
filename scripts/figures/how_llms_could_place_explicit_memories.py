"""Figures for notes/how-llms-could-place-explicit-memories.md.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/how_llms_could_place_explicit_memories.py

Figure 1 plots the largest memory or context each paper tested, as stated in
notes/research/retrieval-attention-lineage-essay-outline.md. Figure 2 is a
hand-placed table of the essay's three placements. The two comparison tables
are also drawn as images, for Substack, which has no tables; the site keeps the
HTML tables, and the images read the essay so they cannot drift from it.
"""

import pathlib
import textwrap

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import FancyBboxPatch, Rectangle  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images"

BG = "#fffff8"
INK = "#2b2b2b"
SLATE = "#53616c"
LIGHT = "#e8eef2"
TEAL = "#258983"
ORANGE = "#c97537"
MAUVE = "#8d5a97"

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 9.5,
    "svg.fonttype": "none",
    "figure.facecolor": BG,
    "axes.facecolor": BG,
    "savefig.facecolor": BG,
})

# (date in years, tokens, label, kind, label offset in points).
POINTS = [
    (2022.21, 262e3, "Memorizing Transformers\n262K, one layer", "beside", (8, 8)),
    (2023.40, 32e3, "Landmark Attention\n32K+", "context", (8, -10)),
    (2023.51, 256e3, "Focused Transformer\n256K, memory layers", "beside", (8, 8)),
    (2026.22, 1e8, "Memory Sparse Attention\n100M, a pooled store", "beside", (-138, 0)),
    (2026.55, 1e6, "The open models of 2026\n1M", "context", (-118, 12)),
    (2026.83, 10e6, "Latent Sparse Attention\n10M, every attention layer", "context", (-150, -6)),
]

KINDS = {
    "beside": ("a memory beside the context", ORANGE),
    "context": ("the context is the memory", TEAL),
}


def timeline():
    fig, ax = plt.subplots(figsize=(7.4, 3.9))
    for kind, (label, colour) in KINDS.items():
        pts = [p for p in POINTS if p[3] == kind]
        ax.scatter([p[0] for p in pts], [p[1] for p in pts], s=46,
                   color=colour, label=label, zorder=3)
    for x, y, text, _, offset in POINTS:
        ax.annotate(text, (x, y), xytext=offset, textcoords="offset points",
                    fontsize=8.5, color=INK, va="center")

    ax.scatter([2026.79], [2.2e4], s=46, marker="D", facecolor=BG,
               edgecolor=MAUVE, linewidth=1.4, zorder=3)
    ax.annotate("Memorilla: a store outside the model,\n"
                "read through 16 tokens (not on this axis)",
                (2026.79, 2.2e4), xytext=(-214, -4),
                textcoords="offset points", fontsize=8.5, color=MAUVE,
                va="center")

    ax.set_yscale("log")
    ax.set_ylim(1e4, 3e8)
    ax.set_xlim(2021.9, 2027.1)
    ax.set_xticks(range(2022, 2028))
    ax.set_ylabel("tokens the store held in testing")
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(SLATE)
    ax.tick_params(colors=SLATE)
    ax.yaxis.label.set_color(SLATE)
    ax.grid(axis="y", color=LIGHT, linewidth=0.8, zorder=0)
    ax.legend(loc="upper left", frameon=False, fontsize=8.5)
    fig.tight_layout()
    return fig


ROWS = [
    ("By position", "where it arrived",
     ["Prefrontal slots: each item of a", "sequence in its own subspace,", "by ordinal position"],
     ["The key–value cache: every token", "keeps its place in the sequence"],
     False),
    ("By content", "what it resembles",
     ["The hippocampal index: pointers", "to the cortical areas that an", "event activated"],
     ["LSA's buckets group keys by", "similarity. Memorilla's reader", "queries a store outside the model"],
     False),
    ("Into connections", "what it taught",
     ["Replay writes the transition", "structure of episodes into", "prefrontal connections"],
     ["Nothing during deployment.", "A recurrent state changes,", "but it ends with the session"],
     True),
]


def placements():
    fig, ax = plt.subplots(figsize=(7.4, 3.75))
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 56)
    ax.axis("off")
    columns = [(23, "A brain", SLATE), (62, "A language model", TEAL)]
    for x, title, colour in columns:
        ax.text(x + 18, 53, title, ha="center", fontsize=10, color=colour,
                fontweight="bold")
    height, gap = 14.5, 2.2
    for i, (name, gloss, brain, model, empty) in enumerate(ROWS):
        y = 50 - (i + 1) * height - i * gap
        ax.text(0, y + height / 2 + 1.8, name, fontsize=10, color=INK,
                fontweight="bold", va="center")
        ax.text(0, y + height / 2 - 2.2, gloss, fontsize=8.5, color=SLATE,
                va="center")
        for (x, _, colour), lines, dashed in zip(columns, (brain, model),
                                                 (False, empty)):
            ax.add_patch(FancyBboxPatch(
                (x, y), 36, height, boxstyle="round,pad=0,rounding_size=1",
                facecolor=BG if dashed else LIGHT, edgecolor=colour,
                linewidth=1.1, linestyle=(0, (3, 2)) if dashed else "-"))
            ax.text(x + 18, y + height / 2, "\n".join(lines), ha="center",
                    va="center", fontsize=8.5, color=INK, linespacing=1.3)
    return fig


TABLES = {
    "place-memories-mt-lsa-table": "| | Memorizing Transformers",
    "place-memories-lsa-memorilla-table": "| | Latent Sparse Attention | Memorilla",
}


def smart(text):
    """Typographic quotes, as pandoc gives the site."""
    text = text.replace("'", "\u2019")
    while '"' in text:
        text = text.replace('"', "\u201c", 1).replace('"', "\u201d", 1)
    return text


def table_rows(header_start):
    """Read one of the essay's pipe tables, found by the start of its header line."""
    lines = (ROOT / "notes/how-llms-could-place-explicit-memories.md").read_text().splitlines()
    start = next(i for i, line in enumerate(lines) if line.startswith(header_start))
    rows = []
    for line in lines[start:]:
        if not line.startswith("|"):
            break
        cells = [smart(c.strip()) for c in line.strip().strip("|").split("|")]
        if not all(set(c) <= {"-", " "} for c in cells):
            rows.append(cells)
    return rows


def figure_table(rows):
    """A two-column comparison table, label column first, cells wrapped to fit."""
    width, first_w, pad, line_h = 8.6, 1.9, 0.1, 0.19
    col_w = (width - first_w - 0.1) / (len(rows[0]) - 1)
    chars = int(col_w / 0.085)
    wrapped = [[textwrap.wrap(c, chars) or [""] for c in r] for r in rows]
    heights = [max(len(c) for c in r) * line_h + 2 * pad for r in wrapped]
    total = sum(heights) + 0.1
    fig, ax = plt.subplots(figsize=(width, total))
    ax.set_xlim(0, width)
    ax.set_ylim(total, 0)
    ax.axis("off")
    fig.subplots_adjust(0, 0, 1, 1)
    xs = [0.12] + [first_w + col_w * i + 0.08 for i in range(len(rows[0]) - 1)]
    y = 0.05
    for r, (cells, h) in enumerate(zip(wrapped, heights)):
        header = r == 0
        if not header and r % 2 == 1:
            ax.add_patch(Rectangle((0.05, y), width - 0.1, h, facecolor=LIGHT, edgecolor="none"))
        for x, cell in zip(xs, cells):
            # One text per line on a shared baseline, so short cells line up with tall ones.
            for k, text in enumerate(cell):
                ax.text(x, y + pad + line_h * (k + 0.75), text, ha="left", va="baseline",
                        color=INK, fontsize=9.3, weight="bold" if header else "normal")
        y += h
        if header:
            ax.plot([0.05, width - 0.05], [y, y], color=SLATE, lw=0.9)
    ax.plot([0.05, width - 0.05], [y, y], color=SLATE, lw=0.9)
    return fig


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, make in (("place-memories-timeline", timeline),
                       ("place-memories-placements", placements)):
        fig = make()
        fig.savefig(OUT / f"{name}.svg", bbox_inches="tight")
        print("wrote", OUT / f"{name}.svg")
    # Substack-only, so their text is drawn as paths: the rasterizer needs no fonts.
    with plt.rc_context({"svg.fonttype": "path"}):
        for name, header_start in TABLES.items():
            fig = figure_table(table_rows(header_start))
            fig.savefig(OUT / f"{name}.svg", metadata={"Date": None})
            plt.close(fig)
            print("wrote", OUT / f"{name}.svg")


if __name__ == "__main__":
    main()
