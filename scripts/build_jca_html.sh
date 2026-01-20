#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

input_md="${1:-$root_dir/projects/jca/Herbrand_JCA.md}"
output_html="${2:-$root_dir/projects/jca/Herbrand_JCA.html}"
css_path="${3:-$root_dir/projects/jca/assets/jca.css}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

if [[ ! -f "$input_md" ]]; then
  echo "error: input file not found: $input_md" >&2
  exit 1
fi

mkdir -p "$(dirname -- "$output_html")"
mkdir -p "$(dirname -- "$css_path")"

if [[ ! -f "$css_path" ]]; then
  cat >"$css_path" <<'CSS'
:root { color-scheme: light; }
body { margin: 0; background: #fff; color: #111; }
main { max-width: 980px; margin: 0 auto; padding: 2.5rem 1.25rem; }
body { font: 16px/1.55 system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji", "Segoe UI Emoji"; }
pre, code { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; font-size: 0.95em; }
h1, h2, h3 { line-height: 1.2; }
h1 { margin-top: 0; }
a { color: #0b57d0; text-decoration: none; }
a:hover { text-decoration: underline; }
blockquote { margin: 1rem 0; padding: 0.25rem 1rem; border-left: 4px solid #ddd; color: #333; }
table { border-collapse: collapse; }
th, td { border: 1px solid #ddd; padding: 0.4rem 0.6rem; }
hr { border: 0; border-top: 1px solid #ddd; margin: 2rem 0; }
CSS
fi

tmp_html="$(mktemp)"
trap 'rm -f "$tmp_html"' EXIT

# Note: use both tex_math_dollars and tex_math_single_backslash so that
# `$...$` and `\(...\)`/`\[...\]` render via MathJax.
pandoc \
  --from=markdown+tex_math_dollars+tex_math_single_backslash \
  --to=html5 \
  --standalone \
  --toc \
  --toc-depth=3 \
  --mathjax="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" \
  --metadata=pagetitle:"Herbrand Constraint Abduction under Quantifier Prefixes" \
  "$input_md" \
  -o "$tmp_html"

# Inline CSS to avoid relative-path issues on some GitHub Pages setups.
python3 - <<PY
from pathlib import Path
import re

tmp_html = Path("$tmp_html").read_text(encoding="utf-8")
css = Path("$css_path").read_text(encoding="utf-8")

style_tag = "<style id=\\"jca-css\\">\\n" + css.strip() + "\\n</style>\\n"

if 'id="jca-css"' in tmp_html:
    out = tmp_html
else:
    out, n = re.subn(r"</head>", style_tag + "</head>", tmp_html, count=1)
    if n != 1:
        raise SystemExit("error: failed to inject CSS (missing </head>)")

Path("$output_html").write_text(out, encoding="utf-8")
PY

echo "wrote: $output_html"
