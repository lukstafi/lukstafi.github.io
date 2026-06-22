#!/usr/bin/env python3
"""Publish a note from notes/ to Substack as a draft.

The article is converted to Substack's ProseMirror draft JSON by the pandoc
custom writer in ``scripts/substack.lua`` (math included, as ``math_inline`` /
``math_display`` nodes), then pushed to Substack via the unofficial
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
import json
import os
import random
import re
import string
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent
LUA_WRITER = SCRIPT_DIR / "substack.lua"
PANDOC_FROM = "markdown+tex_math_dollars+tex_math_single_backslash"
SITE_BASE_URL = "https://lukstafi.github.io"
FOOTER_PREFIX = "Read this on the web (with typeset math): "
PROMPTS_FOOTER_PREFIX = "The prompts behind this essay (the human-side contribution): "

# --- inline LaTeX -> Unicode -------------------------------------------------
# Substack has no inline-math node, so inline `$...$` is rendered as Unicode
# text. This covers the symbol/sub/superscript vocabulary that actually appears
# in the notes; unmapped subscripts fall back to `x_y` rather than being dropped.

_SYM = {
    r"\emptyset": "∅", r"\sqsubseteq": "⊑", r"\sqsupseteq": "⊒", r"\cdot": "·",
    r"\diamond": "⋄", r"\langle": "⟨", r"\rangle": "⟩", r"\models": "⊨",
    r"\circ": "∘", r"\neq": "≠", r"\geq": "≥", r"\leq": "≤", r"\star": "⋆",
    r"\times": "×", r"\sigma": "σ", r"\rho": "ρ", r"\alpha": "α", r"\beta": "β",
    r"\gamma": "γ", r"\delta": "δ", r"\lambda": "λ", r"\mu": "μ", r"\Phi": "Φ",
    r"\phi": "φ", r"\Sigma": "Σ", r"\Pi": "Π", r"\mid": "∣", r"\cup": "∪",
    r"\cap": "∩", r"\in": "∈", r"\notin": "∉", r"\to": "→", r"\mapsto": "↦",
    r"\subseteq": "⊆", r"\supseteq": "⊇", r"\equiv": "≡", r"\approx": "≈",
    r"\forall": "∀", r"\exists": "∃", r"\land": "∧", r"\lor": "∨",
    r"\cong": "≅", r"\sqcup": "⊔", r"\sqcap": "⊓", r"\wedge": "∧", r"\bot": "⊥", r"\top": "⊤",
    r"\pi": "π", r"\theta": "θ", r"\tau": "τ", r"\omega": "ω", r"\epsilon": "ε",
    r"\iota": "ι",
    r"\ldots": "…", r"\dots": "…", r"\cdots": "⋯",
    # stmaryrd brackets (KaTeX on Substack doesn't know these); Unicode here, and
    # `_latex_block` separately rewrites them for the equation path.
    r"\llbracket": "⟦", r"\rrbracket": "⟧",
    r"\quad": " ", r"\qquad": "  ", r"\;": " ", r"\,": " ", r"\:": " ", r"\!": "",
}
_SUB = {c: s for c, s in zip("0123456789aehijklmnoprstuvx+-=",
                             "₀₁₂₃₄₅₆₇₈₉ₐₑₕᵢⱼₖₗₘₙₒₚᵣₛₜᵤᵥₓ₊₋₌")}
_SUP = {c: s for c, s in zip("0123456789ni+-", "⁰¹²³⁴⁵⁶⁷⁸⁹ⁿⁱ⁺⁻")}
_MATHCAL = {"B": "ℬ", "D": "𝒟", "L": "ℒ", "R": "ℛ", "S": "𝒮"}


def _take_group(s: str, i: int):
    """s[i] == '{'; return (inner_text, index_after_closing_brace)."""
    depth, j, buf = 0, i, []
    while j < len(s):
        c = s[j]
        if c == "{":
            depth += 1
            if depth > 1:
                buf.append(c)
        elif c == "}":
            depth -= 1
            if depth == 0:
                return "".join(buf), j + 1
            buf.append(c)
        else:
            buf.append(c)
        j += 1
    return "".join(buf), j


def latex_to_unicode(s: str) -> str:
    """Best-effort conversion of inline LaTeX to Unicode text."""
    # Escaped braces `\{` `\}` are literal characters, not grouping delimiters.
    # Stash them as private-use sentinels so they survive both the group parsing
    # and the unconditional brace-stripping at the end, then restore them.
    s = s.replace(r"\{", "").replace(r"\}", "")
    # Font/formatting macros: keep the argument, drop the wrapper.
    s = re.sub(r"\\(?:texttt|text|mathrm|mathbf|mathsf|mathit|operatorname)\{([^{}]*)\}",
               lambda m: m.group(1), s)
    s = re.sub(r"\\mathcal\{([A-Z])\}", lambda m: _MATHCAL.get(m.group(1), m.group(1)), s)
    s = re.sub(r"\\(?:widehat|hat)\{([^{}]*)\}", lambda m: m.group(1) + "̂", s)
    s = re.sub(r"\\(?:overline|bar)\{([^{}]*)\}", lambda m: m.group(1) + "̄", s)
    s = re.sub(r"\\(?:widetilde|tilde)\{([^{}]*)\}", lambda m: m.group(1) + "̃", s)
    # Negated relations.
    s = s.replace(r"\not\sqsubseteq", "⋢").replace(r"\not\sqsupseteq", "⋣")
    s = s.replace(r"\neq", "≠")
    # Named symbols, longest first so \sqsubseteq beats any prefix.
    for k in sorted(_SYM, key=len, reverse=True):
        s = s.replace(k, _SYM[k])
    # Any remaining \not X -> X with a combining slash.
    s = re.sub(r"\\not\s*(.)", lambda m: m.group(1) + "̸", s)

    def render(content, table):
        if content and all(ch in table for ch in content):
            return "".join(table[ch] for ch in content)
        return None

    out, i = [], 0
    while i < len(s):
        c = s[i]
        if c in "_^" and i + 1 < len(s):
            table = _SUB if c == "_" else _SUP
            if s[i + 1] == "{":
                grp, ni = _take_group(s, i + 1)
                r = render(grp, table)
                out.append(r if r is not None else c + grp)
                i = ni
            else:
                ch = s[i + 1]
                r = render(ch, table)
                out.append(r if r is not None else c + ch)
                i += 2
        else:
            out.append(c)
            i += 1
    text = "".join(out).replace("{", "").replace("}", "")
    text = text.replace("", "{").replace("", "}")
    # Collapse the whitespace that macros like \, and \quad introduce.
    return re.sub(r"[ \t]+", " ", text).strip()


def _latex_block(latex: str) -> dict:
    """Substack's block-equation node."""
    node_id = "".join(random.choices(string.ascii_uppercase, k=10))
    # Substack's KaTeX build lacks the stmaryrd brackets `\llbracket`/`\rrbracket`
    # (they render as an error), so substitute `[[`/`]]` before emitting.
    latex = latex.replace(r"\llbracket", "[[").replace(r"\rrbracket", "]]")
    # Editor-created equations are single-line; embedded newlines make Substack's
    # editor choke on first parse (the recoverable "Something has gone wrong"
    # popup). Whitespace is insignificant in LaTeX outside the `\\` row breaks,
    # so collapse it to one line.
    expr = re.sub(r"\s+", " ", latex).strip()
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


def substackify(body: dict, inline_mode: str = "unicode") -> dict:
    """Rewrite the writer's math sentinels into Substack's real encoding."""

    def inline_repl(node):
        latex = node.get("latex", "")
        if inline_mode == "raw":
            return {"type": "text", "text": f"${latex}$"}
        if inline_mode == "block":
            return _latex_block(latex)
        return {"type": "text", "text": latex_to_unicode(latex)}

    def walk(node):
        if isinstance(node, dict):
            content = node.get("content")
            if isinstance(content, list):
                new = []
                for child in content:
                    if isinstance(child, dict) and child.get("type") == "inline_math":
                        new.append(inline_repl(child))
                    elif isinstance(child, dict) and child.get("type") == "display_math":
                        new.append(_latex_block(child.get("latex", "")))
                    else:
                        new.append(walk(child))
                node["content"] = _merge_text(new)
            return node
        return node

    return walk(body)


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
                        choices=["unicode", "raw", "block"],
                        help="How to render inline $...$ (Substack has no inline "
                             "math): unicode text (default), raw LaTeX, or a "
                             "centered latex_block per expression")
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
    doc["body"] = substackify(doc["body"], args.inline_math)
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

    if args.json_out:
        args.json_out.write_text(json.dumps(doc, ensure_ascii=False, indent=2))
        print(f"wrote JSON: {args.json_out}", file=sys.stderr)

    if args.dry_run:
        json.dump(doc, sys.stdout, ensure_ascii=False, indent=2)
        print()
        return

    repo_root = SCRIPT_DIR.parent
    load_env(repo_root)
    api = make_api()
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
    main()
