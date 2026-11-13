#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

if [ "$#" -gt 1 ]; then
  echo "usage: $0 [markdown-file]" >&2
  exit 2
fi

if [ "$#" -eq 1 ]; then
  if [ ! -f "$1" ]; then
    echo "error: file not found: $1" >&2
    exit 1
  fi
  md_files=("$1")
else
  md_files=("$root_dir"/notes/*.md)
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc not found on PATH" >&2
  exit 1
fi

# Temp file holding the per-article after-body snippet (prompts link / backlink).
after_body="$(mktemp)"
trap 'rm -f "$after_body"' EXIT

for md_file in "${md_files[@]}"; do
  [ -f "$md_file" ] || continue
  base_name="$(basename "$md_file" .md)"
  # Pages are written to notes/. The exception is a source in study/, which is
  # built beside itself: a track's cross-essay questions (published there), or
  # a study page still under review (a preview, published only once its source
  # is moved into notes/).
  out_dir="$root_dir/notes"
  if [ "$(cd -- "$(dirname -- "$md_file")" && pwd)" = "$root_dir/study" ]; then
    out_dir="$root_dir/study"
  fi
  html_file="$out_dir/$base_name.html"

  # Derive title from first H1 heading in the file
  title="$(grep -m1 '^# ' "$md_file" | sed 's/^# //; s/\*\*//g' || true)"
  # Fall back to the YAML frontmatter title for articles carrying no H1.
  if [ -z "$title" ]; then
    title="$(awk 'NR==1 && $0!="---"{exit} NR>1 && $0=="---"{exit} NR>1 && /^title:/{sub(/^title:[[:space:]]*/,""); gsub(/^"|"$/,""); print; exit}' "$md_file")"
  fi
  [ -z "$title" ] && title="$base_name"

  # Build the optional after-body links and page-specific filters.
  #   - A "*.prompts" page links back to its parent article.
  #   - A "*.study" page (recall questions) links back to its parent article
  #     and is laid out by scripts/study.lua. So is a "*.track" page (the
  #     cross-essay questions of a track), which links back to the Study Guide.
  #   - A regular article links forward to its companion prompts and study
  #     pages, where notes/ has them.
  : > "$after_body"
  include_args=()
  filter_args=()
  case "$base_name" in
    *.prompts)
      parent="${base_name%.prompts}"
      printf '%s\n' \
        '<section class="prompts-link"><p><em>From the prompts back to the essay: ' \
        "<a href=\"$parent.html\">$parent.html &rarr;</a></em></p></section>" \
        > "$after_body"
      ;;
    *.study)
      parent="${base_name%.study}"
      printf '%s\n' \
        '<section class="study-link"><p><em>From the study questions back to the essay: ' \
        "<a href=\"/notes/$parent.html\">$parent.html &rarr;</a></em></p></section>" \
        > "$after_body"
      filter_args+=(--lua-filter="$root_dir/scripts/study.lua" --metadata=notes-dir:"$root_dir/notes")
      ;;
    *.track)
      printf '%s\n' \
        '<section class="study-link"><p><em>Back to the tracks: ' \
        '<a href="/study/">Study Guide &rarr;</a></em></p></section>' \
        > "$after_body"
      filter_args+=(--lua-filter="$root_dir/scripts/study.lua" --metadata=notes-dir:"$root_dir/notes")
      ;;
    *)
      if [ -f "$root_dir/notes/$base_name.prompts.md" ]; then
        printf '%s\n' \
          '<section class="prompts-link"><p><em>The prompts behind this essay (the human-side contribution): ' \
          "<a href=\"$base_name.prompts.html\">view the prompts &rarr;</a></em></p></section>" \
          >> "$after_body"
      fi
      if [ -f "$root_dir/notes/$base_name.study.md" ]; then
        printf '%s\n' \
          '<section class="study-link"><p><em>Recall questions for this essay: ' \
          "<a href=\"$base_name.study.html\">view the study questions &rarr;</a></em></p></section>" \
          >> "$after_body"
      fi
      ;;
  esac
  if [ -s "$after_body" ]; then
    include_args+=(--include-after-body="$after_body")
  fi

  # Refresh the dark variant of every SVG figure the article uses
  # (foo.svg -> foo-dark.svg) when it is missing or older than its source.
  while IFS= read -r svg; do
    src="$root_dir/notes/$svg"
    dark="${src%.svg}-dark.svg"
    if [ -f "$src" ] && { [ ! -f "$dark" ] || [ "$src" -nt "$dark" ]; }; then
      python3 "$root_dir/scripts/figures/svg_dark_variant.py" "$src"
    fi
  done < <(grep -oE '\(images/[^)[:space:]]+\.svg\)' "$md_file" | tr -d '()' | grep -v -- '-dark\.svg$' | sort -u || true)

  # Link-preview meta tags (Open Graph, Twitter card) from the index entry.
  og_meta="$(python3 "$root_dir/scripts/og_meta.py" "${out_dir#"$root_dir"/}/$base_name.html" "$title")"

  pandoc \
    --from=markdown+tex_math_dollars+tex_math_single_backslash \
    --to=html5 \
    --standalone \
    --section-divs \
    --katex \
    --lua-filter="$root_dir/scripts/figure_themes.lua" \
    ${filter_args[@]+"${filter_args[@]}"} \
    --template="$root_dir/assets/tufte.html5" \
    --css="/assets/tufte.css" \
    --css="/assets/pandoc-tufte.css" \
    --css="/assets/site.css" \
    --include-before-body="$root_dir/assets/nav.html" \
    ${include_args[@]+"${include_args[@]}"} \
    --metadata=pagetitle:"$title" \
    --variable=og-meta:"$og_meta" \
    "$md_file" \
    -o "$html_file"

  echo "wrote: $html_file"
done
