#!/usr/bin/env python3
"""Convert a note from notes/ (Markdown) to RTF.

The RTF is produced purely as an upload format for Pangram, which accepts only
PDF, docx, RTF and CSV. It is *not* meant for human reading: the goal is to get
the article's prose into a container Pangram can ingest, with math turned into
readable Unicode rather than raw TeX.

The pipeline is:

    Markdown --(pandoc)--> pandoc JSON AST
             --(this script)--> AST with math nodes rewritten to Unicode text
             --(pandoc)--> standalone RTF

Math conversion reuses ``latex_to_unicode`` from ``publish_to_substack`` (the
Substack pipeline already maintains that symbol/sub/superscript vocabulary), so
inline and display math read as e.g. ``d₁ ⊑ d₂`` instead of pandoc's default
``\\u8849 ?`` soup or a raw-TeX fallback.

Usage
-----
    # Write notes/foo.rtf next to the source:
    scripts/md_to_rtf.py notes/foo.md

    # Explicit output path / stdout:
    scripts/md_to_rtf.py notes/foo.md -o /tmp/foo.rtf
    scripts/md_to_rtf.py notes/foo.md -o -

    # Keep math as pandoc's own rendering instead of Unicode text:
    scripts/md_to_rtf.py notes/foo.md --no-unicode-math

Requires pandoc on PATH (same dependency as the Substack pipeline).
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
# Same reader extensions the Substack pipeline uses, so $...$, $$...$$ and
# \(...\) are all recognised as math.
PANDOC_FROM = "markdown+tex_math_dollars+tex_math_single_backslash"

# Reuse the Substack pipeline's LaTeX -> Unicode conversion.
sys.path.insert(0, str(SCRIPT_DIR))
try:
    from publish_to_substack import latex_to_unicode
except Exception:  # pragma: no cover - fall back to leaving math as-is
    def latex_to_unicode(s: str) -> str:
        return s


def _text_to_inlines(text: str) -> list:
    """Turn a plain string into pandoc inline nodes (Str / Space).

    pandoc's ``Str`` must not contain whitespace, so split on runs of it.
    """
    out: list = []
    for piece in re.split(r"(\s+)", text):
        if not piece:
            continue
        if piece.isspace():
            out.append({"t": "Space"})
        else:
            out.append({"t": "Str", "c": piece})
    return out


def rewrite_math(node):
    """Recursively replace every ``Math`` node with Unicode text inlines."""
    if isinstance(node, list):
        out = []
        for item in node:
            if isinstance(item, dict) and item.get("t") == "Math":
                latex = item["c"][1] if len(item["c"]) > 1 else ""
                out.extend(_text_to_inlines(latex_to_unicode(latex)))
            else:
                out.append(rewrite_math(item))
        return out
    if isinstance(node, dict):
        return {k: rewrite_math(v) for k, v in node.items()}
    return node


def pandoc(args: list, stdin: str | None = None) -> str:
    try:
        result = subprocess.run(
            ["pandoc", *args],
            input=stdin,
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        sys.exit("error: pandoc not found on PATH")
    except subprocess.CalledProcessError as exc:
        sys.exit(f"error: pandoc failed:\n{exc.stderr}")
    return result.stdout


def convert(md_path: Path, unicode_math: bool) -> str:
    """Return standalone RTF for the given Markdown file."""
    if unicode_math:
        ast = json.loads(pandoc([f"--from={PANDOC_FROM}", "--to=json", str(md_path)]))
        ast = rewrite_math(ast)
        return pandoc(["--from=json", "--to=rtf", "--standalone"],
                      stdin=json.dumps(ast))
    # Let pandoc render math itself (Unicode where it can, raw TeX otherwise).
    return pandoc([f"--from={PANDOC_FROM}", "--to=rtf", "--standalone", str(md_path)])


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("markdown", type=Path, help="Path to the note's .md file")
    parser.add_argument("-o", "--output", type=Path,
                        help="Output .rtf path, or '-' for stdout "
                             "(default: alongside the source with a .rtf suffix)")
    parser.add_argument("--no-unicode-math", dest="unicode_math",
                        action="store_false",
                        help="Leave math to pandoc's own RTF rendering instead of "
                             "converting it to Unicode text")
    args = parser.parse_args()

    md_path = args.markdown
    if not md_path.exists():
        sys.exit(f"error: file not found: {md_path}")

    rtf = convert(md_path, args.unicode_math)

    if args.output is not None and str(args.output) == "-":
        sys.stdout.write(rtf)
        return

    out_path = args.output or md_path.with_suffix(".rtf")
    out_path.write_text(rtf)
    print(f"wrote {out_path}", file=sys.stderr)


if __name__ == "__main__":
    main()
