#!/usr/bin/env python3
"""Publish a note from notes/ to Substack as a draft.

The article is converted to Substack's ProseMirror draft JSON by the pandoc
custom writer in ``scripts/substack.lua`` (math and media included as export sentinels), then pushed to Substack via the unofficial
``python-substack`` API.

Usage
-----
    # Just produce the JSON and print it (no credentials needed):
    scripts/publish_to_substack.py notes/broadcast-aware-shape-inference.md --dry-run

    # Create a draft on Substack:
    scripts/publish_to_substack.py notes/broadcast-aware-shape-inference.md

    # Create and publish immediately:
    scripts/publish_to_substack.py notes/some-article.md --publish

Authentication (only needed when not --dry-run) is read from the environment or
a .env file in the repo root:

    SUBSTACK_PUBLICATION_URL=https://yourpub.substack.com   (required)
    # then either e-mail/password ...
    SUBSTACK_EMAIL=you@example.com
    SUBSTACK_PASSWORD=...
    # ... or a saved browser session (preferred; avoids captcha):
    SUBSTACK_COOKIES_PATH=scripts/.substack-cookies.json
    SUBSTACK_COOKIES_STRING="cookie1=value1; cookie2=value2"

Install dependencies once:

    pip install -r scripts/requirements-substack.txt
"""

from __future__ import annotations

import argparse
import functools
import json
import os
import random
import re
import string
import subprocess
import sys
from pathlib import Path
from urllib.parse import urljoin

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
LUA_WRITER = SCRIPT_DIR / "substack.lua"
PANDOC_FROM = "markdown+tex_math_dollars+tex_math_single_backslash"
SITE_BASE_URL = "https://lukstafi.github.io"
FOOTER_PREFIX = "Read this on the web (with typeset math): "
PROMPTS_FOOTER_PREFIX = "The prompts behind this essay (the human-side contribution): "

# Pandoc/texmath owns TeX parsing, including nested groups and command boundaries.
# The Lua writer precomputes these strings, avoiding a subprocess per expression.
@functools.lru_cache(maxsize=1024)
def latex_to_unicode(latex: str) -> str:
    result = subprocess.run(
        ["pandoc", "--from=latex", "--to=plain", "--wrap=none"],
        input="$" + latex + "$", text=True, capture_output=True, check=True,
    )
    return result.stdout.strip()


def _expression(latex: str) -> str:
    # Remove TeX comments BEFORE flattening lines, or % comments out the rest.
    latex = re.sub(r"(?<!\\)((?:\\\\)*)%[^\n]*", r"\1", latex)
    latex = latex.replace(r"\llbracket", "⟦").replace(r"\rrbracket", "⟧")
    return re.sub(r"\s+", " ", latex).strip()


def _latex_block(latex: str) -> dict:
    """Substack's block-equation node."""
    node_id = "".join(random.choices(string.ascii_uppercase, k=10))
    expr = _expression(latex)
    return {
        "type": "latex_block",
        "attrs": {"persistentExpression": expr, "id": node_id, "dirty": True},
    }


def _merge_text(nodes: list) -> list:
    """Coalesce adjacent text nodes with identical marks (after inline-math
    conversion may have produced new bare-text neighbours)."""
    out = []
    for n in nodes:
        if (out and isinstance(n, dict) and n.get("type") == "text"
                and out[-1].get("type") == "text"
                and out[-1].get("marks") == n.get("marks")):
            out[-1]["text"] += n["text"]
        else:
            out.append(n)
    return out


def substackify(body: dict, inline_mode: str = "unicode",
                table_mode: str = "list") -> dict:
    """Resolve export sentinels, keeping block nodes out of text containers."""
    from substack_media import render_table

    def walk(node):
        kind = node.get("type")
        if kind == "export_table":
            return [n for block in render_table(node, table_mode) for n in walk(block)]
        if kind == "display_math":
            return [_latex_block(node["latex"])]
        if kind == "inline_math":
            latex = node["latex"]
            marks = node.get("marks")
            if inline_mode == "block":
                return [_latex_block(latex)]
            if inline_mode == "native":
                result = {"type": "inline_latex",
                          "attrs": {"persistentExpression": _expression(latex)}}
            else:
                text = (f"${latex}$" if inline_mode == "raw" else
                        node.get("unicode", None))
                if text is None:
                    text = latex_to_unicode(latex)
                if inline_mode == "unicode" and "\\" in text:
                    print(f"warning: using a block equation for unsupported Unicode math: {latex}",
                          file=sys.stderr)
                    return [_latex_block(latex)]
                result = {"type": "text", "text": text}
            if marks:
                result["marks"] = marks
            return [result] if result.get("text", "nonempty") else []
        if "content" not in node:
            return [dict(node)]
        children = [n for child in node["content"] for n in walk(child)]
        if kind in {"paragraph", "heading", "caption"}:
            # --inline-math block must lift equations, not put them inside a
            # paragraph/heading where ProseMirror rejects them.
            result, current = [], []
            for child in children:
                if child["type"] in {"latex_block", "export_image", "captionedImage"}:
                    if current:
                        result.append({**node, "content": _merge_text(current)})
                    result.append(child)
                    current = []
                else:
                    current.append(child)
            if current or not result:
                result.append({**node, "content": _merge_text(current)})
            return result
        if kind == "list_item" and (not children or children[0]["type"] != "paragraph"):
            children.insert(0, {"type": "paragraph"})
        return [{**node, "content": _merge_text(children)}]

    return walk(body)[0]


def convert(md_path: Path) -> dict:
    """Run pandoc with the Substack Lua writer and return the parsed JSON."""
    if not LUA_WRITER.exists():
        sys.exit(f"error: Lua writer not found at {LUA_WRITER}")
    try:
        result = subprocess.run(
            [
                "pandoc",
                f"--from={PANDOC_FROM}",
                f"--to={LUA_WRITER}",
                str(md_path),
            ],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        sys.exit("error: pandoc not found on PATH")
    except subprocess.CalledProcessError as exc:
        sys.exit(f"error: pandoc failed:\n{exc.stderr}")
    return json.loads(result.stdout)


def load_env(repo_root: Path) -> None:
    """Best-effort load of a .env file (python-dotenv if available, else manual)."""
    env_path = repo_root / ".env"
    try:
        from dotenv import load_dotenv  # type: ignore

        load_dotenv(env_path)
        return
    except ImportError:
        pass
    if env_path.exists():
        for line in env_path.read_text().splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def make_api():
    """Construct an authenticated substack Api from environment variables."""
    try:
        from substack import Api
    except ImportError:
        sys.exit(
            "error: python-substack is not installed.\n"
            "       pip install -r scripts/requirements-substack.txt"
        )

    publication_url = os.getenv("SUBSTACK_PUBLICATION_URL")
    if not publication_url:
        sys.exit("error: SUBSTACK_PUBLICATION_URL is required (see script header)")

    cookies_path = os.getenv("SUBSTACK_COOKIES_PATH")
    cookies_string = os.getenv("SUBSTACK_COOKIES_STRING")
    email = os.getenv("SUBSTACK_EMAIL")
    password = os.getenv("SUBSTACK_PASSWORD")

    if not (cookies_path or cookies_string or (email and password)):
        sys.exit(
            "error: no credentials. Set SUBSTACK_COOKIES_PATH / "
            "SUBSTACK_COOKIES_STRING, or SUBSTACK_EMAIL + SUBSTACK_PASSWORD."
        )

    return Api(
        email=email if not (cookies_path or cookies_string) else None,
        password=password if not (cookies_path or cookies_string) else None,
        cookies_path=cookies_path,
        cookies_string=cookies_string,
        publication_url=publication_url,
    )


def website_url(md_path: Path, site_url: str) -> str:
    """Map a note's .md path to its published .html URL on the website.

    e.g. notes/broadcast-aware-shape-inference.md ->
         https://lukstafi.github.io/notes/broadcast-aware-shape-inference.html
    """
    try:
        rel = md_path.resolve().relative_to(REPO_ROOT)
    except ValueError:
        rel = Path(md_path.name)
    rel_html = rel.with_suffix(".html").as_posix()
    return f"{site_url.rstrip('/')}/{rel_html}"


def prompts_url(md_path: Path, site_url: str) -> str | None:
    """URL of the companion prompts page, or None if there is no companion.

    For notes/foo.md the companion is notes/foo.prompts.md (built to
    notes/foo.prompts.html). A *.prompts.md page has no companion of its own.
    """
    if md_path.name.endswith(".prompts.md"):
        return None
    companion = md_path.with_name(md_path.stem + ".prompts.md")
    if not companion.exists():
        return None
    return website_url(companion, site_url)


def footer_node(url: str, prefix: str) -> dict:
    """A trailing paragraph linking to the article's web version.

    The link carries only the `link` mark (no `code`/`em` combined on the same
    node), since Substack's `code` mark is exclusive and combined marks break the
    editor.
    """
    return {
        "type": "paragraph",
        "content": [
            {"type": "text", "text": prefix, "marks": [{"type": "em"}]},
            {"type": "text", "text": url,
             "marks": [{"type": "link", "attrs": {"href": url}}]},
        ],
    }


def build_post(api, doc: dict, title: str, subtitle: str, audience: str):
    """Build a substack Post whose body is our pre-rendered ProseMirror doc."""
    from substack.post import Post

    user_id = api.get_user_id()
    post = Post(title=title, subtitle=subtitle, user_id=user_id, audience=audience)
    # Our Lua writer already produced the full ProseMirror document, so we set it
    # directly instead of going through Post's per-node builders.
    post.draft_body = doc["body"]
    return post


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("markdown", type=Path, help="Path to the note's .md file")
    parser.add_argument("--title", help="Override the title (default: from frontmatter)")
    parser.add_argument("--subtitle", help="Override the subtitle")
    parser.add_argument("--audience", default="everyone",
                        choices=["everyone", "only_free", "only_paid", "founding"],
                        help="Who can read the post (default: everyone)")
    parser.add_argument("--inline-math", default="unicode",
                        choices=["unicode", "native", "raw", "block"],
                        help="Inline math: Unicode (default), experimental native "
                             "inline LaTeX, raw source, or block equations")
    parser.add_argument("--tables", default="list", choices=["list", "latex"],
                        help="Tables: labeled entries (default) or LaTeX arrays "
                             "for short mathematical tables")
    parser.add_argument("--assets-dir", type=Path,
                        help="Directory for rasterized images (default: beside JSON "
                             "output or under .substack-export/)")
    parser.add_argument("--preview", type=Path,
                        help="Write a local HTML preview of the exported JSON")
    parser.add_argument("--no-footer", action="store_true",
                        help="Do not append the 'read on the web' link footer")
    parser.add_argument("--site-url", default=SITE_BASE_URL,
                        help=f"Website base URL for the footer link (default: {SITE_BASE_URL})")
    parser.add_argument("--footer-prefix", default=FOOTER_PREFIX,
                        help="Text shown before the footer link")
    parser.add_argument("--no-prompts-link", action="store_true",
                        help="Do not append the companion 'prompts behind this "
                             "essay' link footer")
    parser.add_argument("--prompts-footer-prefix", default=PROMPTS_FOOTER_PREFIX,
                        help="Text shown before the prompts-link footer")
    parser.add_argument("--section", help="Substack section name to file the post under")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print the draft JSON and exit (no network, no credentials)")
    parser.add_argument("--json-out", type=Path,
                        help="Also write the draft JSON to this file")
    parser.add_argument("--publish", action="store_true",
                        help="Publish the draft after creating it")
    args = parser.parse_args()

    md_path = args.markdown
    if not md_path.exists():
        sys.exit(f"error: file not found: {md_path}")

    doc = convert(md_path)
    from substack_media import prepare_images, upload_images, write_preview
    doc["body"] = substackify(doc["body"], args.inline_math, args.tables)
    assets_dir = args.assets_dir or ((args.json_out or args.preview).parent / "assets"
                                    if args.json_out or args.preview else
                                    REPO_ROOT / ".substack-export" / md_path.stem)
    prepare_images(doc["body"], md_path, assets_dir)
    from substack_media import nodes
    for node in nodes(doc["body"]):
        for mark in node.get("marks", []):
            if mark["type"] == "link":
                mark["attrs"]["href"] = urljoin(website_url(md_path, args.site_url),
                                                mark["attrs"]["href"])
    if not args.no_footer:
        url = website_url(md_path, args.site_url)
        doc["body"]["content"].append(footer_node(url, args.footer_prefix))
    if not args.no_prompts_link:
        p_url = prompts_url(md_path, args.site_url)
        if p_url:
            doc["body"]["content"].append(
                footer_node(p_url, args.prompts_footer_prefix))
    title = args.title or doc.get("title") or md_path.stem
    subtitle = args.subtitle if args.subtitle is not None else doc.get("subtitle", "")

    doc["title"], doc["subtitle"] = title, subtitle
    if args.preview:
        write_preview(doc, args.preview)
        print(f"wrote preview: {args.preview}", file=sys.stderr)

    api = None
    if not args.dry_run:
        load_env(REPO_ROOT)
        api = make_api()
        upload_images(doc["body"], api)

    if args.json_out:
        args.json_out.parent.mkdir(parents=True, exist_ok=True)
        args.json_out.write_text(json.dumps(doc, ensure_ascii=False, indent=2))
        print(f"wrote JSON: {args.json_out}", file=sys.stderr)

    if args.dry_run:
        json.dump(doc, sys.stdout, ensure_ascii=False, indent=2)
        print()
        return

    post = build_post(api, doc, title, subtitle, args.audience)

    if args.section:
        post.set_section(args.section, api.get_sections())

    draft = api.post_draft(post.get_draft())
    draft_id = draft.get("id")
    print(f"created draft {draft_id}: {title}")

    if args.publish:
        api.prepublish_draft(draft_id)
        api.publish_draft(draft_id)
        print(f"published draft {draft_id}")
    else:
        pub = os.getenv("SUBSTACK_PUBLICATION_URL", "").rstrip("/")
        print(f"edit it at: {pub}/publish/post/{draft_id}")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as exc:
        sys.exit(f"error: {exc}")
