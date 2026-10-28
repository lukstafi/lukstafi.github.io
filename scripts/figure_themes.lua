-- Pair each SVG figure with its dark variant (foo.svg -> foo-dark.svg), when
-- one exists next to it. Both images are emitted; assets/site.css shows the one
-- that matches the page's theme. Variants are written by
-- scripts/figures/svg_dark_variant.py, which scripts/build_notes_html.sh runs.

local input_dir = "."
if PANDOC_STATE.input_files[1] then
  input_dir = pandoc.path.directory(PANDOC_STATE.input_files[1])
end

local function escape(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

-- Write the figure as pandoc would, with two images in place of one. The
-- caption stays aria-hidden because the images' alt text repeats it.
function Figure(fig)
  local plain = fig.content[1]
  if #fig.content ~= 1 or plain.t ~= "Plain" or #plain.content ~= 1
      or plain.content[1].t ~= "Image" then
    return nil
  end
  local src = plain.content[1].src
  if not src:match("%.svg$") or src:match("%-dark%.svg$") or src:match("^%a+://") then
    return nil
  end
  local dark = src:gsub("%.svg$", "-dark.svg")
  if not exists(pandoc.path.join({input_dir, dark})) then
    return nil
  end
  local alt = escape(pandoc.utils.stringify(fig.caption.long))
  local caption = pandoc.write(pandoc.Pandoc(fig.caption.long), "html"):gsub("%s+$", "")
  local id = fig.identifier ~= "" and (' id="' .. escape(fig.identifier) .. '"') or ""
  return pandoc.RawBlock("html",
    "<figure" .. id .. ">\n" ..
    '<img class="fig-light" src="' .. escape(src) .. '" alt="' .. alt .. '" />\n' ..
    '<img class="fig-dark" src="' .. escape(dark) .. '" alt="' .. alt .. '" loading="lazy" />\n' ..
    '<figcaption aria-hidden="true">' .. caption .. "</figcaption>\n" ..
    "</figure>")
end
