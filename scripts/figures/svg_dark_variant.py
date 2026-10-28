"""Write a dark-mode variant next to each SVG figure: foo.svg -> foo-dark.svg.

    python3 scripts/figures/svg_dark_variant.py notes/images/foo.svg [...]

Works on any figure saved by matplotlib with the site's palette, so figures
without a script in the repo get a dark variant too. Light and low-chroma
colours have their luminance inverted onto the dark page's range, keeping
their tint. Saturated mid-tones (the teal, orange and mauve accents) are kept,
since they read on both backgrounds. scripts/build_notes_html.sh runs this
for every figure an article uses, and scripts/figure_themes.lua shows the
variant that matches the page's theme.
"""

import pathlib
import re
import sys

# Page colours from assets/site.css.
LIGHT_BG = "#fffff8"
DARK_BG = "#151515"
DARK_FG = "#d4d4d4"

# White maps a little above the page background, so light fills stay visible.
LO = int(DARK_BG[1:3], 16) / 255 + 0.07
HI = int(DARK_FG[1:3], 16) / 255  # luminance that black maps to


def dark(hex_color):
    h = hex_color.lower()
    if len(h) == 4:
        h = "#" + "".join(c * 2 for c in h[1:])
    if h == LIGHT_BG:
        return DARK_BG
    rgb = [int(h[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    lum = 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]
    chroma = max(rgb) - min(rgb)
    if lum > 0.65 or chroma < 0.15:
        target, keep = LO + (1 - lum) * (HI - LO), 0.7
    else:
        target, keep = max(lum, 0.4), 1.0
    out = [min(1.0, max(0.0, target + keep * (c - lum))) for c in rgb]
    return "#" + "".join(f"{round(c * 255):02x}" for c in out)


COLOR = re.compile(r"((?:fill|stroke|stop-color)(?::\s*|=\"))(#[0-9a-fA-F]{6}\b|#[0-9a-fA-F]{3}\b)")


def convert(svg):
    svg = COLOR.sub(lambda m: m.group(1) + dark(m.group(2)), svg)
    # Text drawn in the default black carries no fill of its own.
    rule = f"text {{fill: {DARK_FG}}}"
    if '<style type="text/css">' in svg:
        return svg.replace('<style type="text/css">', '<style type="text/css">' + rule, 1)
    return re.sub(r"(<svg\b[^>]*>)", r"\1<style>" + rule + "</style>", svg, count=1)


def main(paths):
    for p in map(pathlib.Path, paths):
        if p.stem.endswith("-dark"):
            continue
        out = p.with_name(p.stem + "-dark.svg")
        out.write_text(convert(p.read_text()))
        print("wrote", out)


if __name__ == "__main__":
    main(sys.argv[1:])
