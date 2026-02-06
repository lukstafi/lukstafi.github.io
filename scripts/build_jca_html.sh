#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

input_md="${1:-$root_dir/projects/jca/Herbrand_JCA.md}"
output_html="${2:-$root_dir/projects/jca/Herbrand_JCA.html}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

if [[ ! -f "$input_md" ]]; then
  echo "error: input file not found: $input_md" >&2
  exit 1
fi

mkdir -p "$(dirname -- "$output_html")"

# Note: use both tex_math_dollars and tex_math_single_backslash so that
# `$...$` and `\(...\)`/`\[...\]` render via MathJax.
pandoc \
  --from=markdown+tex_math_dollars+tex_math_single_backslash \
  --to=html5 \
  --standalone \
  --section-divs \
  --template="$root_dir/assets/tufte.html5" \
  --css="/assets/tufte.css" \
  --css="/assets/pandoc-tufte.css" \
  --css="/assets/site.css" \
  --include-before-body="$root_dir/assets/nav.html" \
  --toc \
  --toc-depth=3 \
  --mathjax="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" \
  --metadata=pagetitle:"Herbrand Constraint Abduction under Quantifier Prefixes" \
  "$input_md" \
  -o "$output_html"

echo "wrote: $output_html"
