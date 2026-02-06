# lukstafi.github.io

Personal website and blog. Visit [lukstafi.github.io](https://lukstafi.github.io).

## Building

Requires [Pandoc](https://pandoc.org/) 3.x.

```bash
# Build all HTML from Markdown sources
./scripts/build_all.sh

# Or build individually:
./scripts/build_notes_html.sh
./scripts/build_jca_html.sh
./scripts/build_agent_collab_html.sh
```

### Local preview

```bash
python3 -m http.server
# Then open http://localhost:8000
```

CSS paths are absolute (`/assets/...`), so a local HTTP server is required for previewing — opening HTML files directly via `file://` won't load the stylesheets.

## Design

The site uses [Tufte CSS](https://edwardtufte.github.io/tufte-css/) for typography and layout, with a custom dark mode implementation. Content pages are generated from Markdown via Pandoc using the [tufte-pandoc-css](https://github.com/jez/tufte-pandoc-css) template.
