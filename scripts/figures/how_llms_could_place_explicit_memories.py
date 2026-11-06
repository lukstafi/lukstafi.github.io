"""Figures for notes/how-llms-could-place-explicit-memories.md.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/how_llms_could_place_explicit_memories.py

Figure 1 plots the largest memory or context each paper tested, as stated in
notes/research/retrieval-attention-lineage-essay-outline.md. Figure 2 is a
hand-placed table of the essay's three placements.
"""

import pathlib

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import FancyBboxPatch  # noqa: E402

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


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, make in (("place-memories-timeline", timeline),
                       ("place-memories-placements", placements)):
        fig = make()
        fig.savefig(OUT / f"{name}.svg", bbox_inches="tight")
        print("wrote", OUT / f"{name}.svg")


if __name__ == "__main__":
    main()
