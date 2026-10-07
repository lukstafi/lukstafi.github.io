"""Image transport, table presentation, and previews for the Substack exporter."""
from __future__ import annotations

import base64
import binascii
import copy
import io
import re
import hashlib
import html
import os
from pathlib import Path
from urllib.parse import unquote, urlparse


def nodes(body):
    yield body
    for child in body.get("content", []):
        yield from nodes(child)


def prepare_images(body: dict, markdown: Path, assets_dir: Path) -> None:
    """Resolve images locally; dry runs never upload or fetch remote media."""
    for node in nodes(body):
        if node.get("type") != "export_image":
            continue
        src = node["src"]
        parsed = urlparse(src)
        width = height = size = None
        scale = 1
        if parsed.scheme in {"https", "http"}:
            if parsed.path.lower().endswith(".svg"):
                raise ValueError(f"Use a local copy of the SVG for rasterization: {src}")
        elif parsed.scheme == "data":
            from PIL import Image
            match = re.fullmatch(r"data:(image/(?:png|jpeg|gif|webp));base64,(.*)",
                                 src, re.DOTALL)
            if not match:
                raise ValueError("Embedded images must be base64 PNG/JPEG/GIF/WebP data URIs")
            try:
                data = base64.b64decode(re.sub(r"\s+", "", match[2]), validate=True)
            except binascii.Error as exc:
                raise ValueError("Invalid base64 in embedded image") from exc
            with Image.open(io.BytesIO(data)) as image:
                if Image.MIME.get(image.format) != match[1]:
                    raise ValueError("Embedded image MIME type does not match its contents")
                width, height = image.size
                image.verify()
            size = len(data)
        elif parsed.scheme or parsed.netloc:
            raise ValueError(f"Unsupported image URL scheme: {parsed.scheme}")
        else:
            from PIL import Image
            path = (markdown.resolve().parent / unquote(parsed.path)).resolve()
            if not path.is_file():
                raise ValueError(f"Image not found: {path}")
            if path.suffix.lower() == ".svg":
                scale = 2
                import cairosvg
                assets_dir.mkdir(parents=True, exist_ok=True)
                digest = hashlib.sha256(path.read_bytes()).hexdigest()[:16]
                target = assets_dir.resolve() / f"{path.stem}-{digest}.png"
                # Opaque backing protects black diagram labels in email dark mode.
                cairosvg.svg2png(bytestring=path.read_bytes(), url=str(path),
                                write_to=str(target), scale=2,
                                background_color="white")
                path = target
            with Image.open(path) as image:
                width, height = image.size
                if image.format not in {"PNG", "JPEG", "GIF", "WEBP"}:
                    raise ValueError(f"Unsupported image format: {path}")
            src, size = path.as_uri(), path.stat().st_size
        attrs = {"src": src, "alt": node.get("alt", ""),
                 "title": node.get("title") or None, "fullscreen": False,
                 "imageSize": "normal", "width": width, "height": height,
                 "resizeWidth": min(728, width / scale) if width else 728,
                 "bytes": size}
        content = [{"type": "image2", "attrs": attrs}]
        caption = node.get("caption")
        if caption:
            content.append({"type": "caption", "content": [{"type": "text", "text": caption}]})
        node.clear()
        node.update(type="captionedImage", content=content)


def upload_images(body: dict, api) -> None:
    """Upload once per source; fail before draft creation on an invalid result."""
    uploaded = {}
    for node in nodes(body):
        if node.get("type") != "image2":
            continue
        attrs = node["attrs"]
        src = attrs["src"]
        if src not in uploaded:
            parsed = urlparse(src)
            source = unquote(parsed.path) if parsed.scheme == "file" else src
            response = api.get_image(source)
            url = response.get("url") if isinstance(response, dict) else None
            if not isinstance(url, str) or urlparse(url).scheme != "https":
                raise ValueError(f"Substack did not return an HTTPS image URL for {source}")
            metadata = {"src": url}
            for remote, local in [("imageWidth", "width"), ("imageHeight", "height"),
                                  ("bytes", "bytes"), ("contentType", "type")]:
                if response.get(remote) is not None:
                    metadata[local] = response[remote]
            uploaded[src] = metadata
        attrs.update(uploaded[src])
        if not attrs.get("width") or not attrs.get("height"):
            raise ValueError("Substack image upload did not return intrinsic dimensions")
        attrs["resizeWidth"] = min(attrs.get("resizeWidth") or 728, attrs["width"])


def _cell_inlines(blocks):
    out = []
    for block in blocks:
        if block["type"] in {"inline_math", "display_math", "text", "export_image"}:
            out.append(copy.deepcopy(block))
        else:
            if out and block["type"] in {"paragraph", "heading", "codeBlock"}:
                out.append({"type": "text", "text": " "})
            out.extend(_cell_inlines(block.get("content", [])))
    return out


def _tex_text(text):
    escapes = {"\\": r"\textbackslash{}", "{": r"\{", "}": r"\}",
               "$": r"\$", "&": r"\&", "%": r"\%", "#": r"\#",
               "_": r"\_", "^": r"\textasciicircum{}", "~": r"\textasciitilde{}"}
    return r"\text{" + "".join(escapes.get(c, c) for c in text) + "}"


def render_table(table: dict, mode: str) -> list:
    rows = table["rows"]
    if not rows:
        return []
    result = []
    if mode == "latex":
        width = max(len(row["cells"]) for row in rows)
        rendered = []
        for row in rows:
            cells = []
            for cell in row["cells"]:
                parts = []
                for node in _cell_inlines(cell):
                    if node["type"] == "export_image":
                        raise ValueError("LaTeX tables cannot contain images; use --tables list")
                    parts.append(node["latex"] if node["type"] in {"inline_math", "display_math"}
                                 else _tex_text(node.get("text", "")))
                cells.append(" ".join(parts))
            cells += [""] * (width - len(cells))
            rendered.append(" & ".join(cells) + r" \\" + (r" \hline" if row["header"] else ""))
        result.append({"type": "display_math", "latex": r"\begin{array}{" + "l" * width + "} "
                       + " ".join(rendered) + r" \end{array}"})
    else:
        headers = None
        for row in rows:
            cells = [_cell_inlines(cell) for cell in row["cells"]]
            if row["header"]:
                headers = cells
                # Keep every header, including in a header-only table.
                result.append({"type": "paragraph", "content": _bold(_join(cells, " · "))})
                continue
            paragraphs = []
            for i, cell in enumerate(cells):
                label = headers[i] if headers and i < len(headers) else []
                content = (_bold(copy.deepcopy(label)) + [{"type": "text", "text": ": "}]
                           if label else []) + cell
                paragraphs.append({"type": "paragraph", "content": content})
            result.append({"type": "bullet_list", "content": [
                {"type": "list_item", "content": paragraphs}]})
    if table.get("caption"):
        result.append({"type": "paragraph", "content": [
            {"type": "text", "text": table["caption"], "marks": [{"type": "em"}]}]})
    return result


def _bold(inlines):
    for node in inlines:
        # Code is an exclusive ProseMirror mark.
        if not any(m["type"] == "code" for m in node.get("marks", [])):
            node.setdefault("marks", []).append({"type": "strong"})
    return inlines


def _join(cells, separator):
    result = []
    for cell in cells:
        if result:
            result.append({"type": "text", "text": separator})
        result.extend(copy.deepcopy(cell))
    return result


def write_preview(doc: dict, path: Path) -> None:
    """Render the actual exported nodes, not the original Markdown.

    This preview is an inspection aid, not an assertion of Substack/email parity.
    Math uses KaTeX from its pinned CDN when the preview is opened online.
    """
    esc = html.escape

    def render(node):
        kind = node["type"]
        content = "".join(render(c) for c in node.get("content", []))
        if kind == "text":
            content = esc(node["text"])
            for mark in node.get("marks", []):
                if mark["type"] == "link":
                    content = f'<a href="{esc(mark["attrs"]["href"], quote=True)}">{content}</a>'
                elif mark["type"] in {"strong", "em", "code", "strikethrough"}:
                    tag = "s" if mark["type"] == "strikethrough" else mark["type"]
                    content = f"<{tag}>{content}</{tag}>"
            return content
        if kind in {"latex_block", "inline_latex"}:
            tag = "div" if kind == "latex_block" else "span"
            return f'<{tag} class="math" data-display="{str(kind == "latex_block").lower()}">{esc(node["attrs"]["persistentExpression"])}</{tag}>'
        if kind == "image2":
            src = node["attrs"]["src"]
            if urlparse(src).scheme == "file":
                from urllib.parse import quote
                src = quote(os.path.relpath(unquote(urlparse(src).path), path.resolve().parent))
            width = node["attrs"].get("resizeWidth") or 728
            return f'<img width="{width}" src="{esc(src, quote=True)}" alt="{esc(node["attrs"].get("alt") or "", quote=True)}">'
        if kind == "horizontal_rule":
            return "<hr>"
        if kind == "hard_break":
            return "<br>"
        tag = {"paragraph": "p", "heading": "h" + str(node.get("attrs", {}).get("level", 2)),
               "bullet_list": "ul", "ordered_list": "ol", "list_item": "li",
               "blockquote": "blockquote", "codeBlock": "pre", "captionedImage": "figure",
               "caption": "figcaption", "doc": "article"}.get(kind)
        if not tag:
            raise ValueError(f"Unresolved/unsupported preview node: {kind}")
        return f"<{tag}>{content}</{tag}>"

    page = '''<!doctype html><html lang="en"><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.css">
<style>body{max-width:728px;margin:40px auto;padding:0 20px;color:#222;background:white;font:19px/1.65 Georgia,serif}
h1,h2,h3{line-height:1.2}figure{margin:28px 0}img{max-width:100%;height:auto}figcaption{font:15px/1.5 sans-serif;color:#555}
pre{overflow:auto;font-size:14px}.math[data-display=true]{overflow-x:auto;padding:8px 0}li p{margin:.35em 0}
aside{font:14px/1.5 sans-serif;color:#555;border-bottom:1px solid #ddd;padding-bottom:1em}</style>
'''
    page += f'<title>{esc(doc["title"])}</title><aside>Local export preview — inspect the Substack draft and email preview before publication.</aside><h1>{esc(doc["title"])}</h1>'
    page += render(doc["body"])
    page += '''<script src="https://cdn.jsdelivr.net/npm/katex@0.16.22/dist/katex.min.js"></script>
<script>document.querySelectorAll('.math').forEach(el=>{
try{katex.render(el.textContent,el,{displayMode:el.dataset.display==='true',throwOnError:true})}
catch(e){el.style.color='red';el.title=e.message;el.dataset.error='true'}
});</script></html>'''
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(page)
