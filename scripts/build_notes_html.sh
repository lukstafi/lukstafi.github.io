#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

# Temp file holding the per-article after-body snippet (prompts link / backlink).
after_body="$(mktemp)"
trap 'rm -f "$after_body"' EXIT

for md_file in "$root_dir"/notes/*.md; do
  [ -f "$md_file" ] || continue
  base_name="$(basename "$md_file" .md)"
  html_file="$root_dir/notes/$base_name.html"

  # Derive title from first H1 heading in the file
  title="$(grep -m1 '^# ' "$md_file" | sed 's/^# //; s/\*\*//g' || true)"
  [ -z "$title" ] && title="$base_name"

  # Build the optional after-body link.
  #   - A "*.prompts" page links back to its parent article.
  #   - A regular article links forward to its companion prompts page, if present.
  : > "$after_body"
  include_args=()
  case "$base_name" in
    *.prompts)
      parent="${base_name%.prompts}"
      printf '%s\n' \
        '<section class="prompts-link"><p><em>From the prompts back to the essay: ' \
        "<a href=\"$parent.html\">$parent.html &rarr;</a></em></p></section>" \
        > "$after_body"
      include_args+=(--include-after-body="$after_body")
      ;;
    *)
      if [ -f "$root_dir/notes/$base_name.prompts.md" ]; then
        printf '%s\n' \
          '<section class="prompts-link"><p><em>The prompts behind this essay (the human-side contribution): ' \
          "<a href=\"$base_name.prompts.html\">view the prompts &rarr;</a></em></p></section>" \
          > "$after_body"
        include_args+=(--include-after-body="$after_body")
      fi
      ;;
  esac

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
    "${include_args[@]}" \
    --metadata=pagetitle:"$title" \
    "$md_file" \
    -o "$html_file"

  echo "wrote: $html_file"
done
