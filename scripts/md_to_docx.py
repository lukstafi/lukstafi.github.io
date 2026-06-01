#!/usr/bin/env python3
"""Convert a note from notes/ (Markdown) to .docx.

The .docx is produced purely as an upload format for Pangram, which accepts only
PDF, docx, RTF and CSV. It is *not* meant for human reading.

docx is preferred over RTF here for one specific reason: pandoc renders LaTeX
math as **native Word equations (OMML)**, whereas the RTF path had to flatten
math into inline Unicode text (``d₁ ⊑ d₂``). Unicode math symbols and
sub/superscripts sprinkled through running prose are themselves an LLM "tell",
which is accidental signal when the point is to measure the *prose*. Native
equations keep the surrounding prose plain, so that signal goes away.

This is just a thin pandoc wrapper -- no AST rewriting -- because pandoc already
does the right thing for docx out of the box.

Usage
-----
    # Write notes/foo.docx next to the source:
    scripts/md_to_docx.py notes/foo.md

    # Explicit output path:
    scripts/md_to_docx.py notes/foo.md -o /tmp/foo.docx

    # Also strip smart typography (em dashes, curly quotes, ellipses) down to
    # ASCII, in case those count as "weird Unicode" for your measurement:
    scripts/md_to_docx.py notes/foo.md --ascii-punctuation

Requires pandoc on PATH (same dependency as the Substack pipeline).
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

# Same reader extensions the Substack pipeline uses, so $...$, $$...$$ and
# \(...\) are all recognised as math (and become OMML equations in the .docx).
PANDOC_FROM = "markdown+tex_math_dollars+tex_math_single_backslash"


def convert(md_path: Path, out_path: Path, ascii_punctuation: bool) -> None:
    """Run pandoc to write a .docx for the given Markdown file."""
    # `smart` turns ---/"/... into em dashes, curly quotes and ellipses. Those
    # are faithful to the rendered article, but disabling it keeps everything
    # ASCII for the strictest "no weird Unicode" reading.
    reader = PANDOC_FROM + ("-smart" if ascii_punctuation else "")
    try:
        subprocess.run(
            ["pandoc", f"--from={reader}", "--to=docx",
             str(md_path), "-o", str(out_path)],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        sys.exit("error: pandoc not found on PATH")
    except subprocess.CalledProcessError as exc:
        sys.exit(f"error: pandoc failed:\n{exc.stderr}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("markdown", type=Path, help="Path to the note's .md file")
    parser.add_argument("-o", "--output", type=Path,
                        help="Output .docx path "
                             "(default: alongside the source with a .docx suffix)")
    parser.add_argument("--ascii-punctuation", action="store_true",
                        help="Disable smart typography so em dashes, curly quotes "
                             "and ellipses stay as ASCII (---, \", ...)")
    args = parser.parse_args()

    md_path = args.markdown
    if not md_path.exists():
        sys.exit(f"error: file not found: {md_path}")

    out_path = args.output or md_path.with_suffix(".docx")
    convert(md_path, out_path, args.ascii_punctuation)
    print(f"wrote {out_path}", file=sys.stderr)


if __name__ == "__main__":
    main()
