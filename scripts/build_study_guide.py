#!/usr/bin/env python3
"""Build the Study Guide tab.

Reads study/tracks.yml (the tracks, their stages and essays), the frontmatter
of every notes/*.study.md (what each essay requires, introduces and uses) and
the descriptions in index.html, and writes:

  study/index.html          the tracks: a map and a reading list for each
  study/terms.html          every term the essays introduce, alphabetically
  study/concepts.html       the same terms as a graph of related concepts
  study/<track>.track.html  the cross-essay questions of a track, from
                            study/<track>.track.md (via build_notes_html.sh)

The format of the study pages themselves is documented in scripts/study.lua.
YAML is read through pandoc, so the script needs nothing beyond pandoc and the
standard library.

usage: scripts/build_study_guide.py
"""

import html
import json
import re
import subprocess
import sys
import tempfile
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "scripts"))
from og_meta import SITE_NAME, SITE_URL, index_entries  # noqa: E402

READER = "markdown+tex_math_dollars+tex_math_single_backslash"
NO_QUESTIONS = "Listed for reference, without recall questions."


# ---------------------------------------------------------------- reading

def pandoc_meta(yaml_text):
    """The metadata of a YAML block as plain data, strings kept as markdown."""
    with tempfile.NamedTemporaryFile("w", suffix=".tpl", delete=False) as tpl:
        tpl.write("$meta-json$\n")
    try:
        out = subprocess.run(
            ["pandoc", "-f", "markdown", "-t", "markdown", "--wrap=none",
             f"--template={tpl.name}"],
            input=f"---\n{yaml_text}\n---\n", capture_output=True, text=True, check=True,
        ).stdout
    finally:
        Path(tpl.name).unlink()
    return json.loads(out)


def frontmatter(path):
    text = path.read_text(encoding="utf-8")
    match = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    return pandoc_meta(match.group(1)) if match else {}


def slug_of(text):
    """Identifiers come back from pandoc with markdown escapes; drop them."""
    return text.replace("\\", "").strip()


def essay_title_from_source(slug):
    path = ROOT / "notes" / f"{slug}.md"
    if not path.exists():
        return slug
    text = path.read_text(encoding="utf-8")
    match = re.search(r'^title:\s*"?(.*?)"?\s*$', text[:2000], re.M)
    if not match:
        match = re.search(r"^# (.+)$", text, re.M)
    return match.group(1).replace("**", "").strip() if match else slug


class Site:
    def __init__(self):
        self.tracks = pandoc_meta((ROOT / "study" / "tracks.yml").read_text(encoding="utf-8"))["tracks"]
        self.sidecars = {}
        for path in sorted((ROOT / "notes").glob("*.study.md")):
            meta = frontmatter(path)
            self.sidecars[slug_of(meta["essay"])] = meta
        self.index = index_entries()
        self.track_of = {}
        self.number = {}
        for track in self.tracks:
            n = 0
            for stage in track["stages"]:
                for essay in stage["essays"]:
                    n += 1
                    slug = slug_of(essay["slug"])
                    essay["slug"] = slug
                    self.track_of[slug] = track
                    self.number[slug] = n

    def title(self, slug):
        if slug in self.sidecars:
            return re.sub(r"^Study notes:\s*", "", self.sidecars[slug]["title"])
        entry = self.index.get(f"notes/{slug}.html")
        return md_escape(entry[0]) if entry else md_escape(essay_title_from_source(slug))

    def short_title(self, slug):
        """The title without its subtitle, for maps and cross-references."""
        title = self.title(slug)
        cut = re.match(r"^(.*?\?)\s+\S", title)
        if cut:
            return cut.group(1)
        # "X: The Mathematics" keeps its tail; other subtitles are dropped.
        if ": " in title and not title.endswith(": The Mathematics"):
            return title.split(": ")[0]
        return title

    def description(self, essay):
        if essay.get("gives"):
            return essay["gives"].strip()
        entry = self.index.get(f"notes/{essay['slug']}.html")
        if not entry or not entry[1]:
            return ""
        desc = entry[1]
        # Index descriptions end with an authorship note; the guide omits it.
        for marker in (". By ", ". Written by ", ". Written "):
            cut = desc.rfind(marker)
            if cut != -1:
                desc = desc[: cut + 1]
        return md_escape(desc)

    def has_page(self, slug):
        return slug in self.sidecars

    def requires(self, slug):
        """Essays this one builds on: [(slug, helpful)] in order of first mention."""
        seen = {}
        for req in self.sidecars.get(slug, {}).get("requires") or []:
            target = slug_of(req["at"]).split("#")[0]
            helpful = req.get("strength") == "helpful"
            seen[target] = seen.get(target, True) and helpful
        return list(seen.items())


def md_escape(text):
    return re.sub(r"([\\`*_\[\]$<>])", r"\\\1", text)


def essay_url(slug, section=None):
    return f"/notes/{slug}.html" + (f"#{section}" if section else "")


# ---------------------------------------------------------------- the map

def plain(markdown_text):
    """Markdown inline text as plain text, for SVG labels."""
    text = re.sub(r"\\(.)", r"\1", markdown_text)
    return re.sub(r"[*_`]", "", text)


def track_map(site, track):
    """An arc diagram: the track's essays in reading order, each joined by an
    arc to the earlier essays of the track it builds on."""
    row_height, top = 30, 16
    rows, y = [], top
    for stage in track["stages"]:
        if len(track["stages"]) > 1:
            rows.append(("stage", stage["title"], y))
            y += row_height
        for essay in stage["essays"]:
            rows.append(("essay", essay, y))
            y += row_height
    height = y - row_height + top
    y_of = {row[1]["slug"]: row[2] for row in rows if row[0] == "essay"}

    edges = []
    for slug in y_of:
        for target, helpful in site.requires(slug):
            if target in y_of and target != slug:
                edges.append((target, slug, helpful))
    max_span = max((abs(y_of[a] - y_of[b]) // row_height for a, b, _ in edges), default=0)
    bulge = lambda span: min(16 + 13 * span, 150)
    x0 = bulge(max_span) + 14 if edges else 14

    labels = [plain(site.short_title(row[1]["slug"])) for row in rows if row[0] == "essay"]
    width = int(x0 + 26 + 8.6 * max(len(label) for label in labels) + 12)

    parts = [f'<svg viewBox="0 0 {width} {height}" width="{width}" height="{height}" role="img" '
             f'aria-label="Reading order and prerequisites of the track {html.escape(plain(track["title"]))}">']
    for a, b, helpful in edges:
        ya, yb = y_of[a], y_of[b]
        dx = bulge(abs(ya - yb) // row_height)
        cls = "arc helpful" if helpful else "arc"
        parts.append(f'<path class="{cls}" d="M {x0} {ya} C {x0 - dx} {ya}, {x0 - dx} {yb}, {x0} {yb}"/>')
    for kind, item, y in rows:
        if kind == "stage":
            parts.append(f'<text class="stage" x="{x0 + 20}" y="{y + 5}">{html.escape(plain(item))}</text>')
            continue
        slug = item["slug"]
        muted = " muted" if not site.has_page(slug) else ""
        label = html.escape(plain(site.short_title(slug)))
        parts.append(f'<circle class="node{muted}" cx="{x0}" cy="{y}" r="10"/>')
        parts.append(f'<text class="num{muted}" x="{x0}" y="{y + 4}">{site.number[slug]}</text>')
        parts.append(f'<a href="{essay_url(slug)}"><text class="label{muted}" x="{x0 + 20}" y="{y + 5}">{label}</text></a>')
    parts.append("</svg>")
    caption = "An arc joins an essay to an earlier one it builds on; a dashed arc marks helpful background."
    if not edges:
        caption = "The essays in reading order."
    return ('<figure class="study-map">\n' + "\n".join(parts)
            + f"\n<figcaption>{caption}</figcaption>\n</figure>")


# ---------------------------------------------------------------- pages

def essay_line(site, essay, questions):
    slug = essay["slug"]
    line = f"{site.number[slug]}. [{site.title(slug)}]({essay_url(slug)})"
    if site.has_page(slug) and questions:
        line += f" [study ↗](/notes/{slug}.study.html){{.study-badge}}"
    if essay.get("depth") == "optional":
        line += " [optional]{.study-tag}"
    rest = []
    desc = site.description(essay)
    if desc:
        rest.append(f"[{desc}]{{.study-desc}}")
    if essay.get("note"):
        rest.append(f"[{essay['note'].strip()}]{{.study-desc}}")
    needed = [s for s, helpful in site.requires(slug) if not helpful]
    helpful = [s for s, helpful in site.requires(slug) if helpful]
    link = lambda s: f"[{site.short_title(s)}]({essay_url(s)})"
    builds = []
    if needed:
        builds.append("Builds on " + ", ".join(link(s) for s in needed) + ".")
    if helpful:
        builds.append("Helpful: " + ", ".join(link(s) for s in helpful) + ".")
    if builds:
        rest.append(f"[{' '.join(builds)}]{{.study-builds}}")
    return line + "".join("\\\n    " + part for part in rest)


def guide_markdown(site):
    out = ["---", 'title: "Study Guide"',
           'subtitle: "Reading tracks through the essays, with recall questions"', "---", ""]
    out += [
        "The essays on this site build on one another. This guide sorts them into tracks, "
        "each a reading order, and says what every essay builds on.",
        "",
        "An essay marked [study ↗]{.study-badge} has a page of recall questions. Answer each from memory, "
        "then open the answer to compare. Each track with questions also has a page of questions that "
        "span its essays. The terms the essays introduce are collected in the [index of terms](terms.html), "
        "and the [concept graph](concepts.html) shows which of them are studied together.",
        "",
        "Essays that belong to no track are listed on the [home page](/).",
        "",
    ]
    for track in site.tracks:
        total = sum(len(stage["essays"]) for stage in track["stages"])
        out.append(f"- [{track['title']}](#{track['id']}): {total} essays")
    out.append("")

    for track in site.tracks:
        track_questions = track.get("questions") != "none"
        out += [f"## {track['title']} {{#{track['id']}}}", "", track["blurb"].strip(), ""]
        if not track_questions:
            out += [NO_QUESTIONS, ""]
        out += ["```{=html}", track_map(site, track), "```", ""]
        many = len(track["stages"]) > 1
        for stage in track["stages"]:
            stage_questions = track_questions and stage.get("questions") != "none"
            if many:
                out += [f"### {stage['title']}", ""]
            note = (stage.get("note") or "").strip()
            if not stage_questions and track_questions:
                note = (note + " " + NO_QUESTIONS).strip()
            if note:
                out += [note, ""]
            for essay in stage["essays"]:
                questions = stage_questions and essay.get("questions") != "none"
                out += [essay_line(site, essay, questions), ""]
        if (ROOT / "study" / f"{track['id']}.track.md").exists():
            out += [f"[Questions across this track →]({track['id']}.track.html)", ""]
    return "\n".join(out)


def sort_key(term):
    text = plain(term).casefold()
    text = re.sub(r"^(the|a|an) ", "", text)
    text = text.replace("λ", "lambda")
    text = unicodedata.normalize("NFKD", text)
    return re.sub(r"[^a-z0-9 ]", "", text).strip() or text


def terms_markdown(site):
    entries = []   # (sort key, term, slug, section, gloss)
    used_by = {}   # (term, slug) -> [slugs]
    for slug, meta in site.sidecars.items():
        for item in meta.get("introduces") or []:
            section = slug_of(item["at"]) if item.get("at") else None
            entries.append((sort_key(item["term"]), item["term"], slug, section, (item.get("gloss") or "").strip()))
        for item in meta.get("uses") or []:
            used_by.setdefault((item["term"], slug_of(item["from"])), []).append(slug)
    entries.sort()

    group = lambda key: key[0].upper() if key[0].isalpha() else "0–9"
    anchor = lambda letter: "terms-" + (letter.lower() if letter.isalpha() else "other")
    letters = sorted({group(key) for key, *_ in entries})
    out = ["---", 'title: "Index of terms"',
           'subtitle: "Where each term of the Study Guide is introduced"', "---", "",
           f"The {len(entries)} terms that the essays with study pages introduce. Each links to the section "
           "that introduces it. Where a term is the essays' own, or is used in a stipulated sense, a gloss follows.",
           "",
           "[Back to the Study Guide](/study/) · [Concept graph](concepts.html)", "",
           " · ".join(f"[{letter}](#{anchor(letter)})" for letter in letters), ""]
    current = None
    for key, term, slug, section, gloss in entries:
        letter = group(key)
        if letter != current:
            if current is not None:
                out += [":::", ""]
            current = letter
            out += [f"## {letter} {{#{anchor(letter)}}}", "", "::: study-terms", ""]
        body = (gloss.rstrip(".") + ". ") if gloss else ""
        body += f"*{site.short_title(slug)}*."
        users = used_by.get((term, slug))
        if users:
            body += " Used in " + ", ".join(f"[{site.short_title(u)}]({essay_url(u)})" for u in users) + "."
        out += [f"[{term}]({essay_url(slug, section)})", f":   {body}", ""]
    out += [":::", ""]
    return "\n".join(out)


# ---------------------------------------------------------------- the concept graph
#
# The graph's concepts are the terms of the index. Its links are derived from
# the study pages:
#   section   two terms introduced in the same section of an essay
#   question  two terms named in one question and its answer, in a study page
#             (its own terms and the terms it "uses") or a track's cross-essay
#             questions (the terms of that track)
#   at        a term named in a question, and the terms introduced in the
#             section the question draws on (half weight)
#   related   an optional list on an "introduces" entry, written by hand
#   chain     consecutive terms of one essay, added only where the essay's
#             terms would otherwise fall apart
# A term is named in a text when the text contains it whole, or, for a term
# like "reason, price and defeater", two of its parts or one part of several
# words. Links written by hand are always kept and rank first; any other link
# is kept only if it is among the MAX_LINKS strongest of both its ends.

MAX_LINKS = 10
WEIGHTS = {"related": 3.0, "section": 2.0, "question": 1.0, "at": 0.5}


def term_patterns(term):
    """Whole-term patterns, and part patterns for a composite term."""
    text = plain(term)
    whole = {text}
    m = re.match(r"^(.*?)\s*\((.*?)\)\s*$", text)
    if m:   # "symbol manipulation (Marcus's three hypotheses)"; "... (UQOTOM)"
        whole = {m.group(1)}
        if re.fullmatch(r"[A-Z0-9λ-]+", m.group(2)):
            whole.add(m.group(2))
    base = re.sub(r"\s*\(.*?\)\s*$", "", text)
    parts = re.split(r",\s*(?:and\s+)?|\s+and\s+|\s*/\s*", base)
    if len(parts) < 2:
        parts = []

    def rx(v):
        acronym = re.fullmatch(r"[A-Z0-9λ()-]+", v) and len(v) <= 6
        return re.compile(r"(?<![\w-])" + re.escape(v) + r"(?:s|es)?(?![\w-])", 0 if acronym else re.I)
    return [rx(v) for v in whole], [(rx(v), " " in v) for v in parts]


def names(patterns, text):
    whole, parts = patterns
    if any(p.search(text) for p in whole):
        return True
    found = [long for p, long in parts if p.search(text)]
    return len(found) >= 2 or any(found)


def question_blocks(path):
    """(section, plain text) of each question with its answer."""
    text = re.sub(r"^---\n.*?\n---\n", "", path.read_text(encoding="utf-8"), flags=re.S)
    for block in re.split(r"^(?=#{2,3} )", text, flags=re.M):
        if block.startswith("### "):
            at = re.search(r"\bat=([\w-]+)", block.split("\n", 1)[0])
            yield (at.group(1) if at else None), plain(block)


def concept_graph(site):
    """Concepts in reading order (track, essay, then the essay's own order) and
    their links: {(i, j): kinds}, i < j."""
    concepts = []
    for track_no, track in enumerate(t for t in site.tracks if any(
            e["slug"] in site.sidecars for st in t["stages"] for e in st["essays"])):
        for stage in track["stages"]:
            for essay in stage["essays"]:
                slug = essay["slug"]
                for item in (site.sidecars.get(slug) or {}).get("introduces") or []:
                    concepts.append({
                        "term": item["term"], "slug": slug, "track": track_no,
                        "section": slug_of(item["at"]) if item.get("at") else None,
                        "gloss": (item.get("gloss") or "").strip(),
                        "related": item.get("related") or [],
                    })
    index = {c["term"]: i for i, c in enumerate(concepts)}
    pats = [term_patterns(c["term"]) for c in concepts]
    of_essay, of_section, of_track = {}, {}, {}
    for i, c in enumerate(concepts):
        of_essay.setdefault(c["slug"], []).append(i)
        of_track.setdefault(site.track_of[c["slug"]]["id"], []).append(i)
        if c["section"]:
            of_section.setdefault((c["slug"], c["section"]), []).append(i)

    weight, kinds = {}, {}

    def link(x, y, kind):
        if x == y:
            return
        key = (min(x, y), max(x, y))
        weight[key] = weight.get(key, 0) + WEIGHTS[kind]
        kinds.setdefault(key, set()).add(kind)

    for group in of_section.values():
        for a in group:
            for b in group:
                if a < b:
                    link(a, b, "section")
    for i, c in enumerate(concepts):
        for other in c["related"]:
            if other not in index:
                print(f"warning: {c['slug']}: related term not in the index: {other}", file=sys.stderr)
                continue
            link(i, index[other], "related")

    sources = []
    for slug, meta in site.sidecars.items():
        used = [index[u["term"]] for u in meta.get("uses") or [] if u["term"] in index]
        sources.append((ROOT / "notes" / f"{slug}.study.md", slug, of_essay.get(slug, []) + used))
    for path in sorted((ROOT / "study").glob("*.track.md")):
        sources.append((path, None, of_track.get(path.name.split(".")[0], [])))
    for path, slug, candidates in sources:
        for at, text in question_blocks(path):
            named = [i for i in candidates if names(pats[i], text)]
            for a in named:
                for b in named:
                    if a < b:
                        link(a, b, "question")
            for a in of_section.get((slug, at), []):
                for b in named:
                    link(a, b, "at")

    # Keep the strongest links of each concept.
    rank = {}
    for i in range(len(concepts)):
        mine = sorted((key for key in weight if i in key), key=lambda k: -weight[k])
        for r, key in enumerate(mine):
            rank[(i, key)] = r
    links = {key: kinds[key] for key in weight
             if "related" in kinds[key]
             or (rank[(key[0], key)] < MAX_LINKS and rank[(key[1], key)] < MAX_LINKS)}

    # Keep each essay's terms connected among themselves.
    for slug, members in of_essay.items():
        parent = {i: i for i in members}

        def find(i):
            while parent[i] != i:
                parent[i] = parent[parent[i]]
                i = parent[i]
            return i
        for a, b in links:
            if a in parent and b in parent:
                parent[find(a)] = find(b)
        for a, b in zip(members, members[1:]):
            if find(a) != find(b):
                links[(min(a, b), max(a, b))] = {"chain"}
                parent[find(a)] = find(b)
    return concepts, links


def concept_id(term, taken):
    text = unicodedata.normalize("NFKD", plain(term).replace("λ", "lambda")).casefold()
    base = "concept-" + (re.sub(r"[^a-z0-9]+", "-", text).strip("-") or "term")
    cid, n = base, 2
    while cid in taken:
        cid, n = f"{base}-{n}", n + 1
    taken.add(cid)
    return cid


def concepts_markdown(site):
    concepts, links = concept_graph(site)
    taken = set()
    for c in concepts:
        c["id"] = concept_id(c["term"], taken)
    neighbours = {i: [] for i in range(len(concepts))}
    for a, b in links:
        neighbours[a].append(b)
        neighbours[b].append(a)
    tracks = [t for t in site.tracks if any(e["slug"] in site.sidecars for st in t["stages"] for e in st["essays"])]
    essays = list(dict.fromkeys(c["slug"] for c in concepts))
    data = {
        "tracks": [plain(t["title"]) for t in tracks],
        "essays": [plain(site.short_title(s)) for s in essays],
        "concepts": [[plain(c["term"]), c["id"], c["track"], essays.index(c["slug"])] for c in concepts],
        "links": [[a, b, 1 if kinds == {"chain"} else 0] for (a, b), kinds in sorted(links.items())],
    }
    payload = json.dumps(data, ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")

    legend = "".join(
        f'<li><button type="button" data-track="{n}"><span class="swatch t{n + 1}"></span>'
        f'{html.escape(plain(t["title"]))}</button></li>' for n, t in enumerate(tracks))
    view = f"""<div class="concept-view" hidden>
<div class="concept-graph">
<div class="concept-controls">
<input type="search" id="concept-search" list="concept-names" placeholder="Find a concept" aria-label="Find a concept">
<button type="button" id="concept-overview">Whole graph</button>
</div>
<svg id="concept-svg" viewBox="-340 -340 680 680" role="img" aria-label="Concept graph: the focused concept at the center, its linked concepts on a ring around it, the rest shrinking toward the rim"></svg>
<ul class="concept-legend">{legend}</ul>
</div>
<div class="concept-panel" aria-live="polite">
<p class="concept-hint">Click a concept, or find one by name. Its linked concepts move to the ring around it.</p>
</div>
</div>
<datalist id="concept-names"></datalist>
<script type="application/json" id="concept-data">{payload}</script>
<script src="/assets/concept-graph.js" defer></script>"""

    out = ["---", 'title: "Concept graph"',
           'subtitle: "The terms of the Study Guide and the links between them"', "---", "",
           f"The {len(concepts)} terms of the [index of terms](terms.html), each linked to the terms it is "
           "studied with. Most links were written by hand, from what the essays say about one another. "
           "The rest come from the study pages: two terms introduced in the same section, or named together "
           "in a recall question and its answer. A dashed line only joins consecutive terms of an essay "
           "that would otherwise fall apart.",
           "",
           "Click a concept to bring it to the center. The concepts linked to it form the ring around it; "
           "the rest keep their direction and shrink toward the rim with distance. "
           "The color of a concept is its track.",
           "",
           "[Back to the Study Guide](/study/) · [Index of terms](terms.html)", "",
           "```{=html}", view, "```", "",
           "::: concept-list", ""]
    current_track = current_essay = None
    for i, c in enumerate(concepts):
        if c["track"] != current_track:
            current_track = c["track"]
            out += [f"## {tracks[c['track']]['title']} {{.concept-heading .unnumbered}}", ""]
        if c["slug"] != current_essay:
            current_essay = c["slug"]
            out += [f"### {site.short_title(c['slug'])} {{.concept-heading .unnumbered}}", ""]
        out += [f"::: {{.concept #{c['id']}}}", "",
                f"[{c['term']}]{{.concept-term .t{c['track'] + 1}}}", ""]
        if c["gloss"]:
            out += [c["gloss"][0].upper() + c["gloss"][1:].rstrip(".") + ".", ""]
        out += [f"Introduced in [*{site.short_title(c['slug'])}*]({essay_url(c['slug'], c['section'])}) "
                f"· [study page](/notes/{c['slug']}.study.html) "
                f"· [{tracks[c['track']]['title']}](/study/#{tracks[c['track']]['id']})"
                "{.concept-where}", ""]
        near = sorted(neighbours[i], key=lambda j: (concepts[j]["slug"] != c["slug"], j))
        if near:
            items = []
            for j in near:
                item = f"[{concepts[j]['term']}](#{concepts[j]['id']})"
                if concepts[j]["slug"] != c["slug"]:
                    item += f" [({site.short_title(concepts[j]['slug'])})]{{.concept-from}}"
                items.append(item)
            out += ["Linked to: " + "; ".join(items) + ".", ""]
        out += [":::", ""]
    out += [":::", ""]
    return "\n".join(out)


def og_tags(page, title, description):
    esc = lambda s: html.escape(s, quote=True)
    props = [("og:title", title), ("og:description", description), ("og:url", SITE_URL + page),
             ("og:type", "website"), ("og:site_name", SITE_NAME)]
    lines = [f'<meta name="description" content="{esc(description)}">']
    lines += [f'<meta property="{p}" content="{esc(v)}">' for p, v in props]
    lines.append('<meta name="twitter:card" content="summary">')
    return "\n".join(lines)


def render(markdown_text, page, title, description):
    subprocess.run(
        ["pandoc", f"--from={READER}", "--to=html5", "--standalone", "--section-divs", "--katex",
         f"--template={ROOT / 'assets' / 'tufte.html5'}",
         "--css=/assets/tufte.css", "--css=/assets/pandoc-tufte.css", "--css=/assets/site.css",
         f"--include-before-body={ROOT / 'assets' / 'nav.html'}",
         f"--metadata=pagetitle:{title}", f"--variable=og-meta:{og_tags(page, title, description)}",
         "-o", str(ROOT / page)],
        input=markdown_text, text=True, check=True,
    )
    print(f"wrote: {ROOT / page}")


def main():
    site = Site()
    known = {p.stem for p in (ROOT / "notes").glob("*.md")}
    for slug in site.track_of:
        if slug not in known:
            sys.exit(f"error: study/tracks.yml names an essay that notes/ lacks: {slug}")
    render(guide_markdown(site), "study/index.html", "Study Guide",
           "Reading tracks through the essays, with a map of what builds on what and recall questions for each essay.")
    render(terms_markdown(site), "study/terms.html", "Index of terms",
           "Every term the essays with study pages introduce, with the section that introduces it.")
    render(concepts_markdown(site), "study/concepts.html", "Concept graph",
           "The terms of the Study Guide as a graph: each linked to the terms it is studied with.")
    for path in sorted((ROOT / "study").glob("*.track.md")):
        subprocess.run([str(ROOT / "scripts" / "build_notes_html.sh"), str(path)], check=True)


if __name__ == "__main__":
    main()
