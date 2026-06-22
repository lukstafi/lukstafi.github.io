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

### Publishing a note to Substack

`scripts/publish_to_substack.py` converts a note in `notes/` to Substack's
ProseMirror draft JSON (via the pandoc custom writer `scripts/substack.lua`) and
creates a draft through the unofficial [`python-substack`](https://github.com/ma2za/python-substack) API.

Math: Substack only supports **block** equations (`$$...$$` → a `latex_block`
node), so display math is sent as LaTeX and renders natively. Substack has **no
inline-math** node, so inline `$...$` is converted to Unicode text by default
(`d_1 \sqsubseteq d_2` → `d₁ ⊑ d₂`); use `--inline-math raw` to keep the literal
LaTeX or `--inline-math block` to force a `latex_block` per expression.

Homebrew's Python is "externally managed", so install the dependencies into a
virtualenv:

```bash
python3 -m venv .venv-substack
.venv-substack/bin/pip install -r scripts/requirements-substack.txt

# Preview the generated JSON only (no credentials needed):
.venv-substack/bin/python scripts/publish_to_substack.py \
    notes/broadcast-aware-shape-inference.md --dry-run

# Create a draft (reads credentials from .env / environment):
.venv-substack/bin/python scripts/publish_to_substack.py \
    notes/broadcast-aware-shape-inference.md
```

Credentials go in a `.env` file at the repo root (git-ignored):

```
SUBSTACK_PUBLICATION_URL=https://yourpub.substack.com
# either e-mail/password, or a saved browser session (preferred, avoids captcha):
SUBSTACK_COOKIES_PATH=scripts/.substack-cookies.json
```

The title comes from the note's frontmatter; a leading `# H1` is dropped to
avoid duplicating it. A footer linking to the web version of the article is
appended automatically — the URL is derived from the note's path (e.g.
`notes/foo.md` → `https://lukstafi.github.io/notes/foo.html`); disable with
`--no-footer` or customise with `--site-url` / `--footer-prefix`. Run with
`--help` for all options.

### Prompt companion pages

Each AI-authored article has a companion `notes/<base>.prompts.md` holding the
human-side prompts that steered it — the questions, framing, and
course-corrections — so the author's contribution is delineated from the
writing. These are stubs (`*Prompts not yet transcribed.*`) until filled in.

The links are injected automatically, never written into the article bodies:

- **HTML:** `build_notes_html.sh` appends a footer link from each article to its
  `<base>.prompts.html`, and a backlink from the prompts page to the article,
  whenever the companion `.prompts.md` exists.
- **Substack:** `publish_to_substack.py` appends a prompts-link footer beside the
  web-version backlink (disable with `--no-prompts-link`).
- **Home page:** `index.html` only carries a `prompts ↗` badge for the most
  recent article; the page doubles as a checklist of which stubs are filled in.

### Local preview

```bash
python3 -m http.server
# Then open http://localhost:8000
```

CSS paths are absolute (`/assets/...`), so a local HTTP server is required for previewing — opening HTML files directly via `file://` won't load the stylesheets.

## Design

The site uses [Tufte CSS](https://edwardtufte.github.io/tufte-css/) for typography and layout, with a custom dark mode implementation. Content pages are generated from Markdown via Pandoc using the [tufte-pandoc-css](https://github.com/jez/tufte-pandoc-css) template.
