#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

for md_file in "$root_dir"/notes/*.md; do
  [ -f "$md_file" ] || continue
  base_name="$(basename "$md_file" .md)"
  html_file="$root_dir/notes/$base_name.html"

  # Derive title from first H1 heading in the file
  title="$(grep -m1 '^# ' "$md_file" | sed 's/^# //; s/\*\*//g' || true)"
  [ -z "$title" ] && title="$base_name"

  pandoc \
    --from=markdown+tex_math_dollars+tex_math_single_backslash \
    --to=html5 \
    --standalone \
    --section-divs \
    --katex \
    --template="$root_dir/assets/tufte.html5" \
    --css="/assets/tufte.css" \
    --css="/assets/pandoc-tufte.css" \
    --css="/assets/site.css" \
    --include-before-body="$root_dir/assets/nav.html" \
    --metadata=pagetitle:"$title" \
    "$md_file" \
    -o "$html_file"

  echo "wrote: $html_file"
done
