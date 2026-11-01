"""Figure for notes/variations-on-a-theme.md.

Run from the repository root:

    uv run --with matplotlib python scripts/figures/variations_on_a_theme.py

The scores come from Epoch AI's benchmark data
(https://epoch.ai/data/benchmark_data.zip), downloaded on first run and cached
in ~/.cache/variations-on-a-theme (override with --cache; delete the cache to
refresh). The figure in the note was drawn from the download of 1 November
2026. Each line is a benchmark's frontier: the best score among models
released up to that date, at any reasoning setting.
"""

import argparse
import csv
import datetime as dt
import io
import pathlib
import urllib.request
import zipfile

import matplotlib

matplotlib.use("svg")
import matplotlib.dates as mdates  # noqa: E402
import matplotlib.pyplot as plt  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images/variations-on-a-theme-frontier.svg"
URL = "https://epoch.ai/data/benchmark_data.zip"

BG = "#fffff8"
INK = "#2b2b2b"
MUTED = "#6b6b6b"
GRID = "#e4e4dc"

# Validated with the dataviz skill's palette checker against BG; the
# blue/mauve pair sits in the CVD floor band, so every line also carries a
# distinct marker and a direct label.
BENCHMARKS = [
    # file in the zip, score column, label, colour, marker, label nudge (pt)
    ("arc_agi_2_external.csv", "Score", "ARC-AGI-2", "#3b6ea8", "o", 7),
    ("frontiermath_tiers_1_3_v2.csv", "Best score (across scorers)",
     "FrontierMath,\ntiers 1–3", "#a3478f", "s", -12),
    ("critpt_external.csv", "Accuracy", "CritPt", "#c97537", "^", 0),
]
START = dt.date(2024, 1, 1)
END = dt.date(2026, 10, 31)

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 10,
    "svg.fonttype": "none",
    "figure.facecolor": BG,
    "axes.facecolor": BG,
    "savefig.facecolor": BG,
    "text.color": INK,
    "axes.labelcolor": INK,
    "xtick.color": MUTED,
    "ytick.color": MUTED,
})


def load(cache):
    zpath = cache / "benchmark_data.zip"
    if not zpath.exists():
        cache.mkdir(parents=True, exist_ok=True)
        with urllib.request.urlopen(URL) as r:
            zpath.write_bytes(r.read())
    return zipfile.ZipFile(zpath)


def frontier(zf, name, column):
    """Record-setting (date, score, model) points, in release order."""
    rows = csv.DictReader(io.TextIOWrapper(zf.open(name), encoding="utf-8"))
    points = []
    for r in rows:
        try:
            date = dt.date.fromisoformat(r["Release date"])
            score = 100 * float(r[column])
        except ValueError:
            continue
        points.append((date, score, r["Model version"]))
    points.sort(key=lambda p: (p[0], -p[1]))
    records, best = [], -1.0
    for date, score, model in points:
        if score > best:
            best = score
            records.append((date, score, model))
    return records


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--cache", type=pathlib.Path,
                        default=pathlib.Path.home() / ".cache/variations-on-a-theme")
    args = parser.parse_args()
    zf = load(args.cache)

    fig, ax = plt.subplots(figsize=(7.2, 4.3))
    fig.subplots_adjust(left=0.08, right=0.80, top=0.96, bottom=0.10)
    for name, column, label, colour, marker, nudge in BENCHMARKS:
        records = [p for p in frontier(zf, name, column) if p[0] >= START]
        for date, score, model in records:
            print(f"{label.replace(chr(10), ' ')}\t{date}\t{score:.1f}\t{model}")
        dates = [p[0] for p in records] + [END]
        scores = [p[1] for p in records] + [records[-1][1]]
        ax.step(dates, scores, where="post", color=colour, linewidth=2,
                label=label.replace("\n", " "), solid_capstyle="round")
        ax.plot(dates[:-1], scores[:-1], linestyle="none", marker=marker,
                markersize=6, color=colour, markeredgecolor=BG,
                markeredgewidth=1.2)
        last = records[-1]
        first, _, rest = label.partition("\n")
        text = f"{first} {last[1]:.0f}%" + (f"\n{rest}" if rest else "")
        ax.annotate(text, (END, last[1]),
                    xytext=(6, nudge), textcoords="offset points",
                    va="center", ha="left", fontsize=9, color=INK,
                    annotation_clip=False)

    ax.set_xlim(START, END)
    ax.set_ylim(0, 100)
    ax.set_ylabel("Best score so far (%)")
    ax.xaxis.set_major_locator(mdates.MonthLocator(bymonth=(1, 7)))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%b %Y"))
    ax.yaxis.set_major_locator(plt.MultipleLocator(20))
    ax.grid(axis="y", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(MUTED)
    ax.tick_params(length=3)
    ax.legend(loc="upper left", frameon=False, fontsize=9)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, metadata={"Date": None})
    print("wrote", OUT.relative_to(ROOT))


if __name__ == "__main__":
    main()
