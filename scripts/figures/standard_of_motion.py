"""Figure for notes/the-standard-of-motion-mathematics.md (§3, rotations of a book).

Run from the repository root:

    uv run --with matplotlib --with numpy python scripts/figures/standard_of_motion.py

Two rows turn the same book by a quarter turn about the x axis and a quarter
turn about the y axis (axes fixed in space), in the two possible orders. The
end poses differ, which is the finite-angle face of the Lie bracket
[J_x, J_y] = J_z.
"""

import pathlib

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402
from mpl_toolkits.mplot3d.art3d import Poly3DCollection  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images/standard-of-motion-book-rotations.svg"

BG = "#fffff8"
INK = "#2b2b2b"
MUTED = "#6b6b6b"
COVER = "#3b6ea8"  # front cover (+z face at the start)
SPINE = "#c97537"  # spine (-x face at the start)
PAGES = "#e9e6da"  # the other four faces

plt.rcParams.update({
    "figure.facecolor": BG,
    "savefig.facecolor": BG,
    "text.color": INK,
    "font.size": 10,
    "svg.fonttype": "none",
})

# A book 3 x 2 x 0.6, centred at the origin.
HX, HY, HZ = 1.5, 1.0, 0.3
CORNERS = np.array([[sx * HX, sy * HY, sz * HZ]
                    for sx in (-1, 1) for sy in (-1, 1) for sz in (-1, 1)])


def faces(points):
    idx = lambda sx, sy, sz: ((sx > 0) * 4 + (sy > 0) * 2 + (sz > 0))  # noqa: E731
    quad = {
        "+z": [(-1, -1, 1), (1, -1, 1), (1, 1, 1), (-1, 1, 1)],
        "-z": [(-1, -1, -1), (-1, 1, -1), (1, 1, -1), (1, -1, -1)],
        "-x": [(-1, -1, -1), (-1, -1, 1), (-1, 1, 1), (-1, 1, -1)],
        "+x": [(1, -1, -1), (1, 1, -1), (1, 1, 1), (1, -1, 1)],
        "-y": [(-1, -1, -1), (1, -1, -1), (1, -1, 1), (-1, -1, 1)],
        "+y": [(-1, 1, -1), (-1, 1, 1), (1, 1, 1), (1, 1, -1)],
    }
    colour = {"+z": COVER, "-x": SPINE}
    return [([points[idx(*c)] for c in quad[k]], colour.get(k, PAGES)) for k in quad]


def rot_x(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[1, 0, 0], [0, c, -s], [0, s, c]])


def rot_y(theta):
    c, s = np.cos(theta), np.sin(theta)
    return np.array([[c, 0, s], [0, 1, 0], [-s, 0, c]])


def draw(ax, R, title):
    pts = CORNERS @ R.T
    quads, colours = zip(*faces(pts))
    # One collection, so that matplotlib depth-sorts the faces against each other.
    poly = Poly3DCollection(list(quads), facecolors=list(colours), edgecolor=INK, linewidth=0.6)
    ax.add_collection3d(poly)
    # A small triad of the fixed axes, off to one side so the book never hides it.
    o, L = np.array([-1.6, -1.9, -1.9]), 0.8
    for vec, name in ((np.eye(3)[0], "x"), (np.eye(3)[1], "y"), (np.eye(3)[2], "z")):
        ax.quiver(*o, *(vec * L), color=MUTED, linewidth=0.8, arrow_length_ratio=0.18)
        ax.text(*(o + vec * (L + 0.3)), name, color=MUTED, fontsize=9, ha="center", va="center")
    lim = 2.0
    ax.set_xlim(-lim, lim)
    ax.set_ylim(-lim, lim)
    ax.set_zlim(-lim, lim)
    ax.set_box_aspect((1, 1, 1))
    ax.view_init(elev=22, azim=-58)
    ax.set_axis_off()
    ax.set_facecolor(BG)
    ax.set_title(title, fontsize=10, color=INK, pad=-4)


def main():
    q = np.pi / 2
    rows = [
        [("start", np.eye(3)),
         ("quarter turn about x", rot_x(q)),
         ("then about y", rot_y(q) @ rot_x(q))],
        [("start", np.eye(3)),
         ("quarter turn about y", rot_y(q)),
         ("then about x", rot_x(q) @ rot_y(q))],
    ]
    fig = plt.figure(figsize=(7.2, 5.0))
    for r, row in enumerate(rows):
        for c, (title, R) in enumerate(row):
            ax = fig.add_subplot(2, 3, 3 * r + c + 1, projection="3d")
            draw(ax, R, title)
    fig.text(0.02, 0.74, "x, then y", rotation=90, va="center", color=INK, fontsize=10)
    fig.text(0.02, 0.27, "y, then x", rotation=90, va="center", color=INK, fontsize=10)
    fig.subplots_adjust(left=0.05, right=0.99, top=0.95, bottom=0.02, wspace=0.0, hspace=0.12)
    fig.savefig(OUT)
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
