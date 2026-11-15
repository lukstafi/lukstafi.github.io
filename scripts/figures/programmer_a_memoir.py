"""Figure for notes/programmer-a-memoir.md: the languages, by relation and year.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/programmer_a_memoir.py

One row per language. A filled bar is a stretch in which the language was used,
an orange bar one in which it was taught, an outlined bar one in which it was
known only from reading, a dotted line one in which it is followed from a
distance, and a cross the year a language appeared that was not taken up.

Years before 2003 are the author's estimates; from 2003 they rest on dated
files (see notes/research/language-memoir-essay-outline.md).
"""

import pathlib

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
from matplotlib.lines import Line2D  # noqa: E402
from matplotlib.patches import Patch  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images/programmer-memoir-timeline.svg"

BG = "#fffff8"
INK = "#2b2b2b"
MUTED = "#6b6b6b"
USED = "#3b6ea8"
TAUGHT = "#c97537"
RULE = "#d8d5c8"

plt.rcParams.update({
    "figure.facecolor": BG,
    "savefig.facecolor": BG,
    "axes.facecolor": BG,
    "text.color": INK,
    "font.size": 9.5,
    "svg.fonttype": "none",
})

# (label, [(kind, start, end), ...]); kind in used / taught / paper / follow / cross.
ROWS = [
    ("BASIC (C64, then AMOS)", [("used", 1987, 1996.5)]),
    ("68000 assembly", [("paper", 1993, 1995)]),
    ("LOGO", [("paper", 1996, 1997)]),
    ("HyperTalk", [("used", 1996, 1997.5)]),
    ("Pascal", [("used", 1996.5, 2000), ("taught", 2012.5, 2013.5)]),
    ("DOS batch files", [("used", 1997, 1997.6)]),
    ("C++", [("used", 1997, 2007.5), ("used", 2015.8, 2019.8)]),
    ("Simula", [("paper", 1997, 1998.5)]),
    ("Prolog", [("paper", 1997.5, 1999.5)]),
    ("Lisp", [("paper", 1999, 2001), ("used", 2002, 2004), ("used", 2007, 2007.4)]),
    ("Tcl", [("used", 2000, 2000.8)]),
    # Hand-written OCaml ends with tensor concatenation in OCANNL, December 2025.
    ("OCaml", [("used", 2003, 2015.8), ("taught", 2012.1, 2013.3), ("used", 2022, 2026.0)]),
    ("Nemerle", [("cross", 2004, 2004)]),
    ("Scala", [("cross", 2004, 2004)]),
    # Dated files span Dec 2005 - Jan 2006 (version 05). The start is set to October 2005
    # at the author's word, so that the bar can be seen.
    ("ST6 assembly", [("used", 2005.75, 2006.2)]),
    ("Matlab, Octave", [("taught", 2005, 2009.3), ("used", 2012.2, 2012.5)]),
    ("Lua", [("used", 2007.2, 2007.6)]),
    ("PHP", [("paper", 2007, 2007.8)]),
    ("Coq", [("paper", 2007.5, 2008.3)]),
    ("Haskell", [("taught", 2008.2, 2009.5), ("used", 2014.5, 2014.8)]),
    ("R", [("taught", 2008.5, 2009.3)]),
    ("Java", [("taught", 2011.8, 2012.2)]),
    ("Swift", [("cross", 2014, 2014)]),
    ("Rust", [("cross", 2015, 2015)]),
    ("Python", [("used", 2015.4, 2016.3), ("used", 2019.8, 2021.3)]),
    # All code was hand-written until December 2024; the end of this bar is a conservative guess.
    ("JavaScript, TypeScript", [("used", 2015.4, 2016.3), ("used", 2022, 2025.0)]),
    ("Lean 4", [("follow", 2021, 2026.9)]),
    ("Bend", [("follow", 2024.4, 2026.9)]),
]

X0, X1 = 1986, 2027
H = 0.56


def main():
    n = len(ROWS)
    fig, ax = plt.subplots(figsize=(8.6, 0.27 * n + 1.4))
    for i, (label, spans) in enumerate(ROWS):
        y = n - 1 - i
        ax.axhline(y, color=RULE, lw=0.5, zorder=0)
        ax.text(X0 - 0.6, y, label, ha="right", va="center")
        for kind, a, b in spans:
            w = max(b - a, 0.35)
            if kind == "used":
                ax.barh(y, w, left=a, height=H, color=USED, zorder=2)
            elif kind == "taught":
                ax.barh(y, w, left=a, height=H, color=TAUGHT, zorder=3)
            elif kind == "paper":
                ax.barh(y, w, left=a, height=H, facecolor=BG, edgecolor=INK,
                        lw=0.9, hatch="////", zorder=2)
            elif kind == "follow":
                ax.plot([a, b], [y, y], color=INK, lw=1.6, ls=(0, (1, 2)), zorder=2)
            elif kind == "cross":
                ax.plot([a], [y], marker="x", ms=6.5, mew=1.5, color=MUTED, zorder=2)
    ax.set_xlim(X0, X1)
    ax.set_ylim(-0.8, n - 0.2)
    ax.set_yticks([])
    ax.set_xticks(range(1990, 2027, 5))
    ax.tick_params(axis="x", colors=MUTED, length=3)
    for side in ("left", "right", "top"):
        ax.spines[side].set_visible(False)
    ax.spines["bottom"].set_color(MUTED)
    ax.axvspan(X0, 2003, color=RULE, alpha=0.28, zorder=0, lw=0)
    ax.text(1986.4, -0.55, "estimated", color=MUTED, fontsize=8.5, va="center")
    ax.text(2003.3, -0.55, "from dated files", color=MUTED, fontsize=8.5, va="center")
    legend = [
        Patch(facecolor=USED, label="used"),
        Patch(facecolor=TAUGHT, label="taught"),
        Patch(facecolor=BG, edgecolor=INK, hatch="////", label="known from reading"),
        Line2D([0], [0], color=INK, lw=1.6, ls=(0, (1, 2)), label="followed"),
        Line2D([0], [0], color=MUTED, marker="x", ms=6.5, mew=1.5, lw=0, label="not taken up"),
    ]
    ax.legend(handles=legend, loc="lower center", bbox_to_anchor=(0.42, 1.0), ncol=5,
              frameon=False, handlelength=1.8, columnspacing=1.4)
    fig.subplots_adjust(left=0.24, right=0.985, top=0.93, bottom=0.06)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT)
    print("wrote", OUT.relative_to(ROOT))


if __name__ == "__main__":
    main()
