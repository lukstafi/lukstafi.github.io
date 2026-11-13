-- Study pages: recall questions for one essay, published beside it as
-- notes/<slug>.study.html. scripts/build_notes_html.sh applies this filter to
-- every "*.study.md" (and to "*.track.md", the cross-essay questions of a
-- track). Drafts under review live in study/ and are built there as previews.
--
-- Source format
--
--   Frontmatter
--     title             page title
--     essay             slug of the essay the questions are about
--     track             id of its track in study/tracks.yml
--     reviewed-against  commit of the essay the questions were written
--                       against, in quotes (a bare 12e3456 is a number in YAML)
--     requires          list of {at: slug or slug#section, for: text,
--                       strength: helpful (optional)}
--     introduces        list of {term, at: section (optional), gloss (optional)}
--     uses              list of {term, from: slug}; the term must be in the
--                       "introduces" of that essay's study page
--     see-also          list of {term, at: slug#section}
--     exercises         section of the essay that holds its own exercises
--
--   Body
--     Paragraphs before the first heading are a preamble to the questions.
--     A question is a heading with a kind and, unless it is about the essay's
--     introduction or the essay as a whole, the section it draws on:
--
--       ### Why a baseline is free {kind=derive at=section-id}
--
--     followed by the question, then the answer in a fenced div:
--
--       ::: answer
--       ...
--       :::
--
--   Kinds: compute, derive, state, explain, distinguish, recall, argue,
--   object, case, limits, connect.
--
-- The filter adds an opening line, a "Before reading" list from "requires",
-- a link from each question to its section, a collapsed answer, and a "Terms"
-- list. It reports on stderr a section or essay it cannot find, a question
-- without an answer, and an essay committed again after "reviewed-against".

local stringify = pandoc.utils.stringify

local KINDS = {}
for _, k in ipairs({ "compute", "derive", "state", "explain", "distinguish",
                     "recall", "argue", "object", "case", "limits", "connect" }) do
  KINDS[k] = true
end

local READER = "markdown+tex_math_dollars+tex_math_single_backslash"

local input = PANDOC_STATE.input_files[1] or "."
local input_dir = pandoc.path.directory(input)
local notes_dir = pandoc.path.join({ input_dir, "..", "notes" })

local function warn(msg)
  io.stderr:write("study.lua: " .. input .. ": " .. msg .. "\n")
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local text = f:read("a")
  f:close()
  return text
end

local function inlines(x)
  if x == nil then return pandoc.Inlines({}) end
  if type(x) == "string" then return pandoc.Inlines({ pandoc.Str(x) }) end
  return pandoc.Inlines(x)
end

-- Inlines of a literal sentence written in markdown.
local function md(text)
  return pandoc.read(text, "markdown").blocks[1].content
end

-- Title and section headings of an essay, read from its markdown source.
local essays = {}
local function essay_info(slug)
  if essays[slug] ~= nil then return essays[slug] or nil end
  local text = read_file(pandoc.path.join({ notes_dir, slug .. ".md" }))
  if not text then
    essays[slug] = false
    warn("no essay notes/" .. slug .. ".md")
    return nil
  end
  local doc = pandoc.read(text, READER)
  local info = { sections = {} }
  if doc.meta.title then info.title = inlines(doc.meta.title) end
  doc:walk({
    Header = function(h)
      if h.level == 1 and not info.title then info.title = h.content end
      if h.identifier ~= "" then info.sections[h.identifier] = h.content end
    end,
  })
  info.title = info.title or inlines(slug)
  essays[slug] = info
  return info
end

local function essay_url(slug, section)
  local url = "/notes/" .. slug .. ".html"
  if section and section ~= "" then url = url .. "#" .. section end
  return url
end

-- Warn when the essay has a later commit than the one the questions were
-- reviewed against.
local function check_reviewed(meta, essay)
  if not meta["reviewed-against"] then
    warn("no reviewed-against commit")
    return
  end
  local reviewed = stringify(meta["reviewed-against"])
  local ok, out = pcall(pandoc.pipe, "git",
    { "-C", notes_dir, "log", "-1", "--format=%H", "--", essay .. ".md" }, "")
  local latest = ok and out:gsub("%s+$", "") or ""
  if latest ~= "" and latest:sub(1, #reviewed) ~= reviewed then
    warn(essay .. ".md changed in " .. latest:sub(1, 7) .. " after the questions were reviewed against "
      .. reviewed .. "; re-read them, then update reviewed-against")
  end
end

-- Heading text of a section, or nil (with a warning) when the essay has none.
local function section_title(slug, section)
  local info = essay_info(slug)
  if not info then return nil end
  local title = info.sections[section]
  if not title then warn("no section #" .. section .. " in " .. slug) end
  return title
end

-- A link to an essay, or to one of its sections: Title, "Section".
local function essay_link(target)
  local slug, section = target:match("^([^#]+)#?(.*)$")
  local info = essay_info(slug)
  local text = pandoc.Inlines({ pandoc.Emph(info and info.title or inlines(slug)) })
  local sec = section ~= "" and section_title(slug, section) or nil
  if sec then
    text:extend({ pandoc.Str(","), pandoc.Space(), pandoc.Quoted("DoubleQuote", sec) })
  end
  return pandoc.Link(text, essay_url(slug, sec and section or nil))
end

-- Where another essay's study page says a term is introduced.
local sidecars = {}
local function introduced_at(slug, term)
  if sidecars[slug] == nil then
    sidecars[slug] = false
    for _, dir in ipairs({ input_dir, notes_dir, pandoc.path.join({ notes_dir, "..", "study" }) }) do
      local text = read_file(pandoc.path.join({ dir, slug .. ".study.md" }))
      if text then
        sidecars[slug] = pandoc.read(text, "markdown").meta.introduces or {}
        break
      end
    end
  end
  for _, entry in ipairs(sidecars[slug] or {}) do
    if stringify(entry.term) == term then return entry.at and stringify(entry.at) or "" end
  end
  return nil
end

local function item(...)
  local content = pandoc.Inlines({})
  for _, part in ipairs({ ... }) do
    if type(part) == "string" then content:extend(md(part)) else content:extend(inlines(part)) end
  end
  return { pandoc.Plain(content) }
end

local function before_reading(meta)
  local needed, helpful = {}, {}
  for _, req in ipairs(meta.requires or {}) do
    local entry = item({ essay_link(stringify(req.at)) }, { pandoc.Str(":"), pandoc.Space() }, req["for"], ".")
    if req.strength and stringify(req.strength) == "helpful" then
      table.insert(helpful, entry)
    else
      table.insert(needed, entry)
    end
  end
  local blocks = pandoc.Blocks({})
  if #needed + #helpful == 0 then return blocks end
  blocks:insert(pandoc.Header(2, "Before reading", pandoc.Attr("before-reading")))
  if #needed > 0 then
    blocks:insert(pandoc.Para(md("The essay and these questions assume:")))
    blocks:insert(pandoc.BulletList(needed))
  end
  if #helpful > 0 then
    blocks:insert(pandoc.Para(md("Helpful, not required:")))
    blocks:insert(pandoc.BulletList(helpful))
  end
  return blocks
end

local function terms(meta, essay)
  local blocks = pandoc.Blocks({})
  local introduced, assumed = {}, {}
  for _, entry in ipairs(meta.introduces or {}) do
    -- A term from the essay's introduction, or from an essay without
    -- headings, has no section and links to the essay itself.
    local section = entry.at and stringify(entry.at) or nil
    local found = section and section_title(essay, section)
    local link = pandoc.Link(inlines(entry.term), essay_url(essay, found and section or nil))
    if entry.gloss then
      table.insert(introduced, item({ link }, { pandoc.Str(":"), pandoc.Space() }, entry.gloss, "."))
    else
      table.insert(introduced, item({ link }))
    end
  end
  for _, entry in ipairs(meta.uses or {}) do
    local from = stringify(entry.from)
    local at = introduced_at(from, stringify(entry.term))
    if not at then warn("term '" .. stringify(entry.term) .. "' is not introduced by " .. from) end
    local info = essay_info(from)
    local source = pandoc.Link({ pandoc.Emph(info and info.title or inlines(from)) }, essay_url(from, at))
    table.insert(assumed, item(entry.term, { pandoc.Space(), pandoc.Str("(") }, { source }, { pandoc.Str(")") }))
  end
  for _, entry in ipairs(meta["see-also"] or {}) do
    local also = md(": also in")
    also:insert(pandoc.Space())
    table.insert(assumed, item(entry.term, also, { essay_link(stringify(entry.at)) }, "."))
  end
  if #introduced + #assumed == 0 then return blocks end
  blocks:insert(pandoc.Header(2, "Terms", pandoc.Attr("terms")))
  if #introduced > 0 then
    blocks:insert(pandoc.Para(md("Introduced in this essay:")))
    blocks:insert(pandoc.BulletList(introduced))
  end
  if #assumed > 0 then
    blocks:insert(pandoc.Para(md("From other essays:")))
    blocks:insert(pandoc.BulletList(assumed))
  end
  return blocks
end

-- The line under a question's heading: its kind and the section it draws on.
local function question_meta(header, essay)
  local kind = header.attributes.kind
  if not KINDS[kind] then warn("unknown kind '" .. tostring(kind) .. "'") end
  local line = pandoc.Inlines({ pandoc.Span({ pandoc.Str(kind) }, pandoc.Attr("", { "study-kind" })) })
  local section = header.attributes.at
  if section and essay then
    local title = section_title(essay, section)
    if title then
      local text = pandoc.Inlines(title)
      text:extend({ pandoc.Space(), pandoc.Str("↗") })
      line:extend({ pandoc.Space(), pandoc.Link(text, essay_url(essay, section)) })
    end
  end
  return pandoc.Div({ pandoc.Plain(line) }, pandoc.Attr("", { "study-meta" }))
end

function Pandoc(doc)
  local meta = doc.meta
  if meta["notes-dir"] then notes_dir = stringify(meta["notes-dir"]) end
  local essay = meta.essay and stringify(meta.essay) or nil

  local preamble, questions = pandoc.Blocks({}), pandoc.Blocks({})
  local seen_header, open_question = false, nil
  for _, block in ipairs(doc.blocks) do
    if block.t == "Header" then
      seen_header = true
      if open_question then warn("question without an answer: " .. open_question) end
      open_question = nil
      local meta_line = nil
      if block.attributes.kind then
        open_question = stringify(block.content)
        meta_line = question_meta(block, essay)
        -- Keep the kind on the page as a data attribute; "kind" and "at"
        -- themselves are not HTML attributes.
        block.attributes["data-kind"] = block.attributes.kind
        block.attributes.kind = nil
        block.attributes.at = nil
      end
      questions:insert(block)
      if meta_line then questions:insert(meta_line) end
    elseif block.t == "Div" and block.classes:includes("answer") then
      if not open_question then warn("answer without a question") end
      open_question = nil
      questions:insert(pandoc.RawBlock("html", '<details class="answer"><summary>Answer</summary>'))
      questions:extend(block.content)
      questions:insert(pandoc.RawBlock("html", "</details>"))
    elseif seen_header then
      questions:insert(block)
    else
      preamble:insert(block)
    end
  end
  if open_question then warn("question without an answer: " .. open_question) end

  local out = pandoc.Blocks({})
  if essay then
    check_reviewed(meta, essay)
    local intro = md("Recall questions for")
    intro:extend({ pandoc.Space(), essay_link(essay) })
    intro:extend(md(". Answer each from memory, then open the answer to compare. The link under a question leads to the section it draws on."))
    out:insert(pandoc.Para(intro))
    out:extend(before_reading(meta))
    out:insert(pandoc.Header(2, "Questions", pandoc.Attr("questions")))
  end
  out:extend(preamble)
  out:extend(questions)
  if essay then
    if meta.exercises then
      local section = stringify(meta.exercises)
      if section_title(essay, section) then
        local line = md("For problems that go beyond recall, the essay has its own")
        line:extend({ pandoc.Space(), pandoc.Link(md("exercises"), essay_url(essay, section)), pandoc.Str(".") })
        out:insert(pandoc.Para(line))
      end
    end
    out:extend(terms(meta, essay))
  end
  return pandoc.Pandoc(out, meta)
end
