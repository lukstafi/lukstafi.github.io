#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
collab_dir="$root_dir/projects/jca/agent-collab"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

# Build function for a single markdown file
build_html() {
  local input_md="$1"
  local output_html="$2"
  local title="$3"

  if [[ ! -f "$input_md" ]]; then
    echo "warning: input file not found: $input_md" >&2
    return 1
  fi

  mkdir -p "$(dirname -- "$output_html")"

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
    --metadata=pagetitle:"$title" \
    "$input_md" \
    -o "$output_html"

  echo "wrote: $output_html"
}

# Build main collaboration papers
build_html \
  "$collab_dir/collab-paper-claude.md" \
  "$collab_dir/collab-paper-claude.html" \
  "JCAQP Undecidability Analysis - Claude"

build_html \
  "$collab_dir/collab-paper-codex.md" \
  "$collab_dir/collab-paper-codex.html" \
  "JCAQP Undecidability Analysis - Codex"

build_html \
  "$collab_dir/round-8-reassessment.md" \
  "$collab_dir/round-8-reassessment.html" \
  "JCA Existence over T(F), Round 8: Reassessment"

# Build all review files
reviews_dir="$collab_dir/reviews"
if [[ -d "$reviews_dir" ]]; then
  for md_file in "$reviews_dir"/*.md; do
    if [[ -f "$md_file" ]]; then
      base_name="$(basename "$md_file" .md)"
      html_file="$reviews_dir/$base_name.html"
      title="Agent Collaboration Review: $base_name"
      build_html "$md_file" "$html_file" "$title"
    fi
  done
fi

echo "All agent-collab HTML files built successfully."
