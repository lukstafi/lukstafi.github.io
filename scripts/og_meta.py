#!/usr/bin/env python3
"""Print link-preview meta tags (Open Graph, Twitter card) for a built page.

usage: og_meta.py PAGE_PATH FALLBACK_TITLE

PAGE_PATH is the page's path relative to the site root (e.g. notes/foo.html).
Title and description come from the page's entry in index.html: the entry's
main link text and its <span class="description">. A page with no entry falls
back to FALLBACK_TITLE (its <title>); a "*.prompts.html" page borrows its
parent essay's entry for the description.
"""

import html
import re
import sys
from html.parser import HTMLParser
from pathlib import Path

SITE_URL = "https://lukstafi.github.io/"
SITE_NAME = "lukstafi's blog"

ROOT = Path(__file__).resolve().parent.parent


class IndexParser(HTMLParser):
    """Collect {href: (title, description)} from the post list of index.html."""

    def __init__(self):
        super().__init__()
        self.entries = {}
        self.in_item = False
        self.in_desc = False
        self.link = None  # href of the main link being read, if any
        self.reset_item()

    def reset_item(self):
        self.title_href = None
        self.title = ""
        self.desc = ""
        self.desc_links = []  # (href, text) of links inside the description
        self.desc_link = None

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        cls = attrs.get("class") or ""
        if tag == "li" and "post-item" in cls.split():
            self.in_item = True
            self.reset_item()
        elif not self.in_item:
            return
        elif tag == "span" and cls == "description":
            self.in_desc = True
        elif tag == "a" and self.in_desc:
            self.desc_link = [attrs.get("href"), ""]
        elif tag == "a" and not cls and self.title_href is None:
            self.title_href = attrs.get("href")
            self.link = self.title_href

    def handle_endtag(self, tag):
        if not self.in_item:
            return
        if tag == "a":
            if self.desc_link is not None:
                self.desc_links.append(tuple(self.desc_link))
                self.desc_link = None
            self.link = None
        elif tag == "span" and self.in_desc:
            self.in_desc = False
        elif tag == "li":
            self.in_item = False
            self.finish_item()

    def handle_data(self, data):
        if not self.in_item:
            return
        if self.in_desc:
            self.desc += data
            if self.desc_link is not None:
                self.desc_link[1] += data
        elif self.link is not None:
            self.title += data

    def finish_item(self):
        title = squash(self.title)
        desc = squash(self.desc)
        if not self.title_href or not title:
            return
        # Mind-map entries link to a PDF and offer the HTML page as
        # "Also: HTML"; that trailer is navigation, not description.
        desc = re.sub(r"\s*Also:.*$", "", desc)
        self.entries.setdefault(self.title_href, (title, desc))
        for href, text in self.desc_links:
            if href and squash(text) == "HTML":
                self.entries.setdefault(href, (title, desc))


def squash(text):
    return re.sub(r"\s+", " ", text).strip()


def index_entries():
    parser = IndexParser()
    parser.feed((ROOT / "index.html").read_text(encoding="utf-8"))
    return parser.entries


def meta_tags(page, fallback_title):
    entries = index_entries()
    title, desc = entries.get(page, (fallback_title, ""))
    if page not in entries and page.endswith(".prompts.html"):
        parent = page[: -len(".prompts.html")] + ".html"
        if parent in entries:
            title = f"Prompts: {entries[parent][0]}"
            desc = f"The prompts behind the essay “{entries[parent][0]}”."
    esc = lambda s: html.escape(s, quote=True)
    props = [
        ("og:title", title),
        ("og:description", desc),
        ("og:url", SITE_URL + page),
        ("og:type", "article"),
        ("og:site_name", SITE_NAME),
    ]
    lines = []
    if desc:
        lines.append(f'<meta name="description" content="{esc(desc)}">')
    for prop, value in props:
        if value:
            lines.append(f'<meta property="{prop}" content="{esc(value)}">')
    lines.append('<meta name="twitter:card" content="summary">')
    return "\n".join(lines)


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    print(meta_tags(sys.argv[1], sys.argv[2]))


if __name__ == "__main__":
    main()
