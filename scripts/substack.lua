--[[
Pandoc custom writer: Substack draft JSON.

Emits the JSON expected by Substack's (unofficial) draft API: a ProseMirror
document plus the post metadata the `python-substack` library needs. The shape
is:

    {
      "title":    "...",
      "subtitle": "...",
      "body":     { "type": "doc", "content": [ ...ProseMirror nodes... ] }
    }

`body` is the value that becomes the draft body; `title`/`subtitle` are pulled
from the document metadata (YAML frontmatter). Math is emitted as sentinel nodes
-- `{type="inline_math", latex=...}` for `$...$` and `{type="display_math",
latex=...}` for `$$...$$` -- which `publish_to_substack.py` rewrites into
Substack's real encoding (display math becomes a `latex_block`; inline math
becomes Unicode text, because Substack has no inline-math node).

Usage:

    pandoc --from=markdown+tex_math_dollars+tex_math_single_backslash \
           --to=scripts/substack.lua article.md

Pandoc >= 3.0 (uses the `Writer(doc, opts)` custom-writer API).
]]

local stringify = pandoc.utils.stringify

-- Map a Pandoc inline mark onto a ProseMirror mark, or nil if unsupported.
local function clone_marks(marks)
  local out = {}
  for i, m in ipairs(marks) do
    if m.type == "link" then
      out[i] = { type = "link", attrs = { href = m.attrs.href } }
    else
      out[i] = { type = m.type }
    end
  end
  return out
end

-- Append a ProseMirror text node carrying the current mark stack.
local function push_text(nodes, text, marks)
  if text == "" then return end
  local node = { type = "text", text = text }
  if marks and #marks > 0 then
    node.marks = clone_marks(marks)
  end
  nodes[#nodes + 1] = node
end

-- Emit math as sentinel nodes; the Python side turns these into Substack's
-- actual encoding (display -> latex_block, inline -> Unicode text), since
-- Substack has no inline-math node at all.
local function math_node(el)
  local kind = el.mathtype == "DisplayMath" and "display_math" or "inline_math"
  return { type = kind, latex = el.text }
end

-- Deep-equality of two ProseMirror mark lists (order-sensitive; links compared
-- by href). Treats nil and {} alike.
local function marks_equal(a, b)
  a = a or {}
  b = b or {}
  if #a ~= #b then return false end
  for i = 1, #a do
    if a[i].type ~= b[i].type then return false end
    if a[i].type == "link" then
      local ha = a[i].attrs and a[i].attrs.href
      local hb = b[i].attrs and b[i].attrs.href
      if ha ~= hb then return false end
    end
  end
  return true
end

-- Substack's `code` mark is exclusive: a text node cannot carry `code`
-- alongside any other mark (e.g. a code span inside a link, `[`x`](url)`).
-- Such a node throws on load in Substack's editor. Resolve the conflict by
-- keeping the link when present (the functional part), otherwise keeping only
-- code.
local function normalize_marks(marks)
  if not marks or #marks < 2 then return marks end
  local has_code, has_link = false, false
  for _, m in ipairs(marks) do
    if m.type == "code" then has_code = true end
    if m.type == "link" then has_link = true end
  end
  if not has_code then return marks end
  local out = {}
  if has_link then
    for _, m in ipairs(marks) do
      if m.type ~= "code" then out[#out + 1] = m end
    end
  else
    out = { { type = "code" } }
  end
  return out
end

-- Coalesce adjacent text nodes carrying identical marks. Pandoc emits a separate
-- Str/Space for every word and space; ProseMirror expects runs of same-styled
-- text in a single node.
local function merge_text(nodes)
  local out = {}
  for _, n in ipairs(nodes) do
    if n.type == "text" then n.marks = normalize_marks(n.marks) end
    local prev = out[#out]
    if prev and prev.type == "text" and n.type == "text"
        and marks_equal(prev.marks, n.marks) then
      prev.text = prev.text .. n.text
    else
      out[#out + 1] = n
    end
  end
  return out
end

-- Pandoc passes raw HTML inline tags (<code>, </code>, etc.) as RawInline
-- elements when they appear inside raw-HTML blocks. Convert <code>...</code>
-- sequences into proper Code inlines so the rest of the pipeline handles them.
local function preprocess_inlines(inlines)
  local out = {}
  local i = 1
  while i <= #inlines do
    local el = inlines[i]
    if el.tag == "RawInline" and el.format == "html" then
      local tag = el.text:match("^%s*(.-)%s*$"):lower()
      if tag == "<code>" then
        i = i + 1
        local buf = {}
        while i <= #inlines do
          local inner = inlines[i]
          if inner.tag == "RawInline" and inner.format == "html"
              and inner.text:match("^%s*(.-)%s*$"):lower() == "</code>" then
            i = i + 1; break
          end
          if inner.tag == "Str" then buf[#buf + 1] = inner.text
          elseif inner.tag == "Space" then buf[#buf + 1] = " "
          else buf[#buf + 1] = stringify(inner)
          end
          i = i + 1
        end
        out[#out + 1] = pandoc.Code(table.concat(buf))
      else
        -- other raw HTML inlines (e.g. <br />) — skip the tag itself
        i = i + 1
      end
    else
      out[#out + 1] = el
      i = i + 1
    end
  end
  return out
end

-- Convert a list of Pandoc inlines into ProseMirror inline nodes. `marks` is the
-- stack of active marks (each a table like {type="strong"} or a link).
local inlines_to_nodes
inlines_to_nodes = function(inlines, marks)
  inlines = preprocess_inlines(inlines)
  marks = marks or {}
  local nodes = {}
  for _, el in ipairs(inlines) do
    local t = el.tag
    if t == "Str" then
      push_text(nodes, el.text, marks)
    elseif t == "Space" or t == "SoftBreak" then
      push_text(nodes, " ", marks)
    elseif t == "LineBreak" then
      nodes[#nodes + 1] = { type = "hard_break" }
    elseif t == "Emph" or t == "Underline" then
      local sub = inlines_to_nodes(el.content, marks)
      for _, n in ipairs(sub) do
        n.marks = n.marks or {}
        n.marks[#n.marks + 1] = { type = "em" }
        nodes[#nodes + 1] = n
      end
    elseif t == "Strong" then
      local sub = inlines_to_nodes(el.content, marks)
      for _, n in ipairs(sub) do
        n.marks = n.marks or {}
        n.marks[#n.marks + 1] = { type = "strong" }
        nodes[#nodes + 1] = n
      end
    elseif t == "Strikeout" then
      local sub = inlines_to_nodes(el.content, marks)
      for _, n in ipairs(sub) do
        n.marks = n.marks or {}
        n.marks[#n.marks + 1] = { type = "strikethrough" }
        nodes[#nodes + 1] = n
      end
    elseif t == "Code" then
      local with = {}
      for i, m in ipairs(marks) do with[i] = m end
      with[#with + 1] = { type = "code" }
      push_text(nodes, el.text, with)
    elseif t == "Link" then
      local with = {}
      for i, m in ipairs(marks) do with[i] = m end
      with[#with + 1] = { type = "link", attrs = { href = el.target } }
      for _, n in ipairs(inlines_to_nodes(el.content, with)) do
        nodes[#nodes + 1] = n
      end
    elseif t == "Math" then
      nodes[#nodes + 1] = math_node(el)
    elseif t == "Quoted" then
      local q = el.quotetype == "SingleQuote" and "'" or '"'
      push_text(nodes, q, marks)
      for _, n in ipairs(inlines_to_nodes(el.content, marks)) do
        nodes[#nodes + 1] = n
      end
      push_text(nodes, q, marks)
    elseif t == "Span" then
      for _, n in ipairs(inlines_to_nodes(el.content, marks)) do
        nodes[#nodes + 1] = n
      end
    elseif t == "Note" then
      -- No footnote node in this pipeline: inline the content parenthetically.
      push_text(nodes, " (", marks)
      for _, blk in ipairs(el.content) do
        if blk.content then
          for _, n in ipairs(inlines_to_nodes(blk.content, marks)) do
            nodes[#nodes + 1] = n
          end
        end
      end
      push_text(nodes, ")", marks)
    else
      -- RawInline, Cite, etc.: fall back to plain text.
      push_text(nodes, stringify(el), marks)
    end
  end
  return merge_text(nodes)
end

local blocks_to_nodes

-- Drop leading/trailing whitespace-only text nodes (left over after lifting a
-- display-math block out of the middle of a paragraph).
local function trim_ws(nodes)
  while #nodes > 0 and nodes[1].type == "text" and nodes[1].text:match("^%s*$") do
    table.remove(nodes, 1)
  end
  while #nodes > 0 and nodes[#nodes].type == "text" and nodes[#nodes].text:match("^%s*$") do
    table.remove(nodes, #nodes)
  end
  return nodes
end

-- Turn a Para/Plain's inlines into one or more ProseMirror block nodes. A
-- display-math (`$$...$$`) is a block node in Substack, so any that appear
-- inside the paragraph are lifted out, splitting the surrounding text into
-- separate paragraphs around each math_display block.
local function para_blocks(inlines)
  local blocks = {}
  local current = {}

  local function flush()
    local nodes = trim_ws(inlines_to_nodes(current, {}))
    if #nodes > 0 then
      blocks[#blocks + 1] = { type = "paragraph", content = nodes }
    end
    current = {}
  end

  for _, el in ipairs(inlines) do
    if el.tag == "Math" and el.mathtype == "DisplayMath" then
      flush()
      blocks[#blocks + 1] = math_node(el)
    else
      current[#current + 1] = el
    end
  end
  flush()

  if #blocks == 0 then blocks[1] = { type = "paragraph" } end
  return blocks
end

-- Check if a block is a specific raw HTML tag (opening or closing).
local function raw_html_tag(blk, name, closing)
  if blk.tag ~= "RawBlock" or blk.format ~= "html" then return false end
  local txt = blk.text:match("^%s*(.-)%s*$"):lower()
  if closing then
    return txt == "</" .. name .. ">"
  else
    return txt == "<" .. name .. ">" or txt:match("^<" .. name .. "[%s/>]") ~= nil
  end
end

-- Pandoc emits each HTML tag as its own RawBlock, with cell content as normal
-- Para/Plain blocks in between. Group the flat sequence into synthetic HtmlTable
-- blocks so blocks_to_nodes can convert them to ProseMirror table nodes.
local function preprocess_blocks(blocks)
  local out = {}
  local i = 1
  while i <= #blocks do
    local blk = blocks[i]
    if raw_html_tag(blk, "table", false) then
      local rows, cur_row, cell_is_header, cell_blocks = {}, nil, false, {}
      i = i + 1
      while i <= #blocks do
        local b = blocks[i]
        if raw_html_tag(b, "table", true) then
          i = i + 1; break
        elseif raw_html_tag(b, "tr", false) then
          cur_row = {}
        elseif raw_html_tag(b, "tr", true) then
          if cur_row then rows[#rows + 1] = cur_row end; cur_row = nil
        elseif raw_html_tag(b, "th", false) then
          cell_is_header = true; cell_blocks = {}
        elseif raw_html_tag(b, "td", false) then
          cell_is_header = false; cell_blocks = {}
        elseif raw_html_tag(b, "th", true) or raw_html_tag(b, "td", true) then
          if cur_row then
            cur_row[#cur_row + 1] = {
              tag = cell_is_header and "HtmlTh" or "HtmlTd",
              content = cell_blocks,
            }
          end
          cell_blocks = {}
        elseif b.tag == "RawBlock" and b.format == "html" then
          -- skip other structural tags: thead, tbody, etc.
        else
          cell_blocks[#cell_blocks + 1] = b
        end
        i = i + 1
      end
      out[#out + 1] = { tag = "HtmlTable", rows = rows }
    else
      out[#out + 1] = blk
      i = i + 1
    end
  end
  return out
end

local function list_items(items)
  local out = {}
  for i, item in ipairs(items) do
    out[i] = { type = "list_item", content = blocks_to_nodes(item) }
  end
  return out
end

blocks_to_nodes = function(blocks)
  blocks = preprocess_blocks(blocks)
  local nodes = {}
  for _, blk in ipairs(blocks) do
    local t = blk.tag
    if t == "Para" or t == "Plain" then
      for _, n in ipairs(para_blocks(blk.content)) do
        nodes[#nodes + 1] = n
      end
    elseif t == "Header" then
      nodes[#nodes + 1] = {
        type = "heading",
        attrs = { level = blk.level },
        content = inlines_to_nodes(blk.content, {}),
      }
    elseif t == "CodeBlock" then
      local node = {
        type = "codeBlock",
        content = { { type = "text", text = blk.text } },
      }
      local lang = blk.classes and blk.classes[1]
      if lang and lang ~= "" then node.attrs = { language = lang } end
      nodes[#nodes + 1] = node
    elseif t == "BlockQuote" then
      nodes[#nodes + 1] = { type = "blockquote", content = blocks_to_nodes(blk.content) }
    elseif t == "BulletList" then
      nodes[#nodes + 1] = { type = "bullet_list", content = list_items(blk.content) }
    elseif t == "OrderedList" then
      local node = { type = "ordered_list", content = list_items(blk.content) }
      local start = blk.start or (blk.listAttributes and blk.listAttributes.start)
      if start and start ~= 1 then node.attrs = { order = start } end
      nodes[#nodes + 1] = node
    elseif t == "HorizontalRule" then
      nodes[#nodes + 1] = { type = "horizontal_rule" }
    elseif t == "Div" then
      for _, n in ipairs(blocks_to_nodes(blk.content)) do
        nodes[#nodes + 1] = n
      end
    elseif t == "HtmlTable" then
      -- Substack has no native table support; render each row as a paragraph
      -- with cells joined by " | ". Header cells are bolded.
      local function cell_inlines(cell)
        local ils = {}
        for _, b in ipairs(cell.content) do
          if b.tag == "Para" or b.tag == "Plain" then
            for _, il in ipairs(b.content) do ils[#ils + 1] = il end
          end
        end
        return ils
      end
      for _, row in ipairs(blk.rows) do
        local parts = {}
        for ci, cell in ipairs(row) do
          local ils = cell_inlines(cell)
          if cell.tag == "HtmlTh" and #ils > 0 then
            ils = { pandoc.Strong(ils) }
          end
          for _, il in ipairs(ils) do parts[#parts + 1] = il end
          if ci < #row then parts[#parts + 1] = pandoc.Str(" | ") end
        end
        nodes[#nodes + 1] = { type = "paragraph", content = inlines_to_nodes(parts, {}) }
      end
    elseif t == "RawBlock" then
      -- skip remaining raw HTML/TeX blocks (not part of a table)
    else
      -- Tables and anything else: best-effort plain-text paragraph.
      local txt = stringify(blk)
      if txt ~= "" then
        nodes[#nodes + 1] = { type = "paragraph", content = { { type = "text", text = txt } } }
      end
    end
  end
  return nodes
end

function Writer(doc, opts)
  local meta = doc.meta
  local blocks = doc.blocks

  -- Drop a leading level-1 heading: the title lives in metadata, and Substack
  -- shows it separately, so keeping the H1 would duplicate it in the body.
  if #blocks > 0 and blocks[1].tag == "Header" and blocks[1].level == 1 then
    table.remove(blocks, 1)
  end

  local title = meta.title and stringify(meta.title) or ""
  local subtitle = meta.subtitle and stringify(meta.subtitle) or ""

  local out = {
    title = title,
    subtitle = subtitle,
    body = { type = "doc", content = blocks_to_nodes(blocks) },
  }

  return pandoc.json.encode(out)
end
