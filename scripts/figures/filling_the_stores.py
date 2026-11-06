"""Figures for notes/filling-the-stores.md.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/filling_the_stores.py

Figure 1 is hand-placed from the disclosures in Table 1 of the essay and the
reports notes/research/training-primary-*-2026-11-06.md. Positions within a
stage carry order only: a stage's width says nothing about its token budget.
"""

import pathlib

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.patches import FancyArrowPatch, FancyBboxPatch, Rectangle  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images"

BG = "#fffff8"
INK = "#2b2b2b"
SLATE = "#53616c"
LIGHT = "#e8eef2"
TEAL = "#258983"
ORANGE = "#c97537"
MAUVE = "#8d5a97"
GREY = "#b0b0b0"

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 9.5,
    "svg.fonttype": "none",
    "figure.facecolor": BG,
    "axes.facecolor": BG,
    "savefig.facecolor": BG,
})

STAGES = ["Pretraining", "Mid-training", "SFT", "RL", "Distillation"]

KINDS = {
    "context": ("longest context", TEAL),
    "precision": ("quantization", ORANGE),
    "selection": ("selection", MAUVE),
    "modality": ("modalities", SLATE),
}

# Each row: (label, [(x in stage units, text, kind)], note, note x).
ROWS = [
    ("MiMo-V2.6-Pro", [(0.62, "vision", "modality"), (1.14, "4-bit", "precision"), (1.74, "1M", "context")], None, None),
    ("Kimi K3", [(0.20, "vision", "modality"), (1.72, "1M", "context"), (2.22, "4-bit", "precision")], None, None),
    ("Kimi K3.1 Pro", [], "selection added; the stage is not disclosed", 1.05),
    ("Qwen3.8-2.4T", [], "card says only: “Pre-training & Post-training”", 0.05),
    ("GLM-5", [(1.50, "200K", "context"), (1.78, "select", "selection"), (2.22, "4-bit", "precision")], None, None),
    ("GLM-5.2, 5.3", [(1.28, "select", "selection")], "1M: stage not given", 2.05),
    ("DeepSeek-V4-Pro", [(0.44, "select", "selection"), (0.80, "1M", "context")], None, None),
    ("DeepSeek-V4.1-Flash", [(0.04, "select", "selection"), (0.41, "vision", "modality"), (0.78, "1M", "context")], None, None),
    ("MiniMax-M3", [(0.20, "vision", "modality")], None, None),
    ("MAI-Thinking-1", [(1.74, "256K", "context")], "16-bit through RL", 3.05),
]

ROW_H = 0.62
GAP_BEFORE_LAST = 0.34


def chip(ax, x, y, text, color):
    width = 0.042 * len(text) + 0.09
    ax.add_patch(
        FancyBboxPatch(
            (x, y - 0.16), width, 0.32,
            boxstyle="round,pad=0.0,rounding_size=0.09",
            fc=color, ec="none", zorder=3,
        )
    )
    ax.text(x + width / 2, y - 0.005, text, ha="center", va="center", color="white", fontsize=8.2, zorder=4)


def figure_timeline():
    fig, ax = plt.subplots(figsize=(8.6, 5.7))
    n = len(ROWS)
    height = n * ROW_H + GAP_BEFORE_LAST
    ax.set_xlim(-1.62, 5.02)
    ax.set_ylim(-0.1, height + 0.62)
    ax.axis("off")

    for i, name in enumerate(STAGES):
        if i % 2 == 0:
            ax.add_patch(Rectangle((i, 0), 1, height, fc=LIGHT, ec="none", zorder=0))
        ax.text(i + 0.5, height + 0.34, name, ha="center", va="bottom", color=INK, fontsize=9.5, weight="bold")

    positions = {}
    for row, (label, events, note, note_x) in enumerate(ROWS):
        y = height - (row + 0.5) * ROW_H
        if row == n - 1:
            y -= GAP_BEFORE_LAST
            ax.plot([-1.6, 5], [y + ROW_H / 2 + GAP_BEFORE_LAST / 2] * 2, color=GREY, lw=0.8)
        positions[label] = y
        ax.plot([0, 5], [y, y], color=GREY, lw=0.6, zorder=1)
        ax.text(-0.08, y, label, ha="right", va="center", color=INK)
        for x, text, kind in events:
            chip(ax, x, y, text, KINDS[kind][1])
        if note:
            ax.text(note_x, y + 0.03, note, ha="left", va="bottom", color=SLATE, fontsize=8.4, style="italic")

    # K3.1 Pro: the selector exists after K3's pretraining; its stage is unknown.
    y = positions["Kimi K3.1 Pro"]
    ax.plot([1.02, 4.95], [y, y], color=MAUVE, lw=2.2, ls=(0, (3, 2)), zorder=2)

    # Quantization that the reports place only "in post-training".
    for label, text in (("DeepSeek-V4-Pro", "4-bit"), ("DeepSeek-V4.1-Flash", "4-bit cache")):
        y = positions[label]
        ax.plot([2.02, 4.95], [y, y], color=ORANGE, lw=2.2, ls=(0, (3, 2)), zorder=2)
        chip(ax, 2.05, y, text, ORANGE)

    # MiMo: RL's failures go back into mid-training.
    y = positions["MiMo-V2.6-Pro"]
    ax.add_patch(
        FancyArrowPatch(
            (3.55, y + 0.05), (1.62, y + 0.1),
            connectionstyle="arc3,rad=0.22", arrowstyle="-|>", mutation_scale=9,
            color=INK, lw=1.0, zorder=5,
        )
    )
    ax.text(2.62, y + 0.33, "early hacking cases go back", ha="center", va="center", color=INK, fontsize=8.2,
            bbox={"fc": BG, "ec": "none", "pad": 0.8}, zorder=6)

    handles = [
        plt.Line2D([0], [0], marker="s", ls="", ms=8, color=color, label=name)
        for name, color in KINDS.values()
    ]
    ax.legend(handles=handles, loc="upper center", bbox_to_anchor=(0.56, 0.015), ncol=4, frameon=False, fontsize=8.8,
              handletextpad=0.3, columnspacing=1.4)
    fig.subplots_adjust(left=0.01, right=0.995, top=0.995, bottom=0.05)
    return fig


def main():
    OUT.mkdir(exist_ok=True)
    for name, build in {"filling-the-stores-timeline": figure_timeline}.items():
        fig = build()
        fig.savefig(OUT / f"{name}.svg", metadata={"Date": None})
        plt.close(fig)
        print("wrote", OUT / f"{name}.svg")


if __name__ == "__main__":
    main()
