-- ~/.config/nvim/lua/plugins/neorg.lua

-- ── Config ────────────────────────────────────────────────────────────────────

local NOTES_ROOT = vim.fn.expand("~/work/notes")

local function notes_root()
  return NOTES_ROOT
end

-- ── Template loader ───────────────────────────────────────────────────────────
-- Reads from ~/work/notes/templates/*.norg
-- To change a template, edit the .norg file — no Lua changes needed.

local function load_template(name)
  local path = notes_root() .. "/templates/" .. name .. ".norg"
  local f = io.open(path, "r")
  if not f then
    vim.notify("Template not found: " .. path, vim.log.levels.WARN)
    return {}
  end
  local lines = {}
  for line in f:lines() do
    lines[#lines + 1] = line
  end
  f:close()
  return lines
end

-- Replace {placeholder} tokens in a list of lines
local function apply_tokens(lines, tokens)
  local result = {}
  for _, line in ipairs(lines) do
    for key, val in pairs(tokens) do
      line = line:gsub("{" .. key .. "}", val)
    end
    result[#result + 1] = line
  end
  return result
end

-- ── Open helper ───────────────────────────────────────────────────────────────
-- Opens a file and inserts lines only if the buffer is new/empty.
-- cursor_line: line number to jump to after insertion (optional)

local function open_with_template(path, lines, cursor_line)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  local existing = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local is_empty = #existing == 0 or (#existing == 1 and existing[1] == "")
  if is_empty and #lines > 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    if cursor_line then
      vim.cmd("normal! " .. cursor_line .. "G$")
    end
  end
end

-- ── Note creation ─────────────────────────────────────────────────────────────

local neorg_helpers = {}

function neorg_helpers.create_permanent_note()
  local id = os.date("%Y%m%d%H%M%S")
  local title = vim.fn.input("Note title: ")
  if title == "" then
    return
  end
  local slug = title:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")
  local path = notes_root() .. "/permanent/" .. id .. "-" .. slug .. ".norg"
  local lines = apply_tokens(load_template("permanent"), {
    title = title,
    id = id,
    date = os.date("%Y-%m-%d"),
  })
  open_with_template(path, lines, 13)
end

function neorg_helpers.create_area()
  local name = vim.fn.input("Area name: ")
  if name == "" then
    return
  end
  local slug = name:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")
  local path = notes_root() .. "/areas/" .. slug .. "/index.norg"
  local lines = apply_tokens(load_template("area"), {
    area = name,
    date = os.date("%Y-%m-%d"),
  })
  open_with_template(path, lines, 11)
end

function neorg_helpers.create_project()
  local name = vim.fn.input("Project name: ")
  if name == "" then
    return
  end
  local slug = name:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")
  local base = notes_root() .. "/projects/" .. slug

  -- Create todo.norg stub if it doesn't exist yet
  local todo_path = base .. "/todo.norg"
  if vim.fn.filereadable(todo_path) == 0 then
    local todo_lines = apply_tokens(load_template("todo"), {
      title = name,
      date = os.date("%Y-%m-%d"),
    })
    -- todo template is optional — fall back to minimal stub
    if #todo_lines == 0 then
      todo_lines = {
        "@document.meta",
        "title: " .. name .. " — TODO",
        "created: " .. os.date("%Y-%m-%d"),
        "tags: [project, todo]",
        "@end",
        "",
        "* " .. name .. " TODO",
        "",
        "** In Progress",
        "",
        "   - ( ) ",
        "",
        "** Up Next",
        "",
        "   - ( ) ",
        "",
        "** Done",
        "",
        "   - (x) ",
      }
    end
    vim.fn.mkdir(base, "p")
    local f = io.open(todo_path, "w")
    if f then
      f:write(table.concat(todo_lines, "\n"))
      f:close()
    end
  end

  local index_lines = apply_tokens(load_template("area"), {
    area = name,
    date = os.date("%Y-%m-%d"),
  })
  open_with_template(base .. "/index.norg", index_lines, 11)
end

-- Journal: Neorg's default path is fleeting/YYYY/MM/DD.norg
-- We open that same path and insert the fleeting template if it's a new file.
function neorg_helpers.journal_today()
  local y, m, d = os.date("%Y"), os.date("%m"), os.date("%d")
  local date = y .. "-" .. m .. "-" .. d
  local path = notes_root() .. "/fleeting/" .. y .. "/" .. m .. "/" .. d .. ".norg"
  local lines = apply_tokens(load_template("fleeting"), {
    date = date,
  })
  open_with_template(path, lines, 15)
end

function neorg_helpers.journal_yesterday()
  local t = os.time() - 86400
  local y, m, d = os.date("%Y", t), os.date("%m", t), os.date("%d", t)
  local date = y .. "-" .. m .. "-" .. d
  local path = notes_root() .. "/fleeting/" .. y .. "/" .. m .. "/" .. d .. ".norg"
  local lines = apply_tokens(load_template("fleeting"), {
    date = date,
  })
  open_with_template(path, lines, 15)
end

function neorg_helpers.create_domain_note()
  local project = vim.fn.input("Project (default: cora): ")
  if project == "" then
    project = "cora"
  end
  local slug_project = project:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")

  local title = vim.fn.input("Domain note title: ")
  if title == "" then
    return
  end
  local slug = title:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")

  local path = notes_root() .. "/projects/" .. slug_project .. "/domain/" .. slug .. ".norg"
  local lines = apply_tokens(load_template("permanent"), {
    title = title,
    id = os.date("%Y%m%d%H%M%S"),
    date = os.date("%Y-%m-%d"),
  })
  open_with_template(path, lines, 13)
end

function neorg_helpers.regenerate_index()
  local current_file = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(current_file, ":h")
  local notes_root_abs = vim.fn.fnamemodify(notes_root(), ":p"):gsub("/$", "")

  -- Derive the tag from the area/project folder name
  -- e.g. .../areas/dsa/index.norg → tag = "dsa"
  local tag = dir:match("/areas/([^/]+)$") or dir:match("/projects/([^/]+)$")
  if not tag then
    vim.notify("Not inside an areas/ or projects/ index — cannot derive tag", vim.log.levels.WARN)
    return
  end

  -- rg: find all .norg files whose tags line contains this tag
  local cmd = string.format("rg --glob '*.norg' --files-with-matches 'tags:.*%s' %s", tag, notes_root_abs)
  local handle = io.popen(cmd)
  if not handle then
    vim.notify("rg failed", vim.log.levels.ERROR)
    return
  end

  local links = {}
  for filepath in handle:lines() do
    -- Skip index files themselves
    if not filepath:match("index%.norg$") then
      -- Read title from @document.meta if present, else derive from filename
      local title = nil
      local f = io.open(filepath, "r")
      if f then
        for line in f:lines() do
          local t = line:match("^title:%s*(.+)$")
          if t then
            title = t
            break
          end
          if line:match("^@end") then
            break
          end
        end
        f:close()
      end
      if not title then
        title = vim.fn.fnamemodify(filepath, ":t:r"):gsub("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%-", ""):gsub("-", " ")
      end
      -- Build workspace-root-anchored link
      local rel = filepath:gsub(vim.pesc(notes_root_abs), ""):gsub("%.norg$", ""):match("^[/]*(.*)")
      links[#links + 1] = "   - {:$/" .. rel .. ":}[" .. title .. "]"
    end
  end
  handle:close()

  table.sort(links)

  if #links == 0 then
    vim.notify("No notes found tagged [" .. tag .. "]", vim.log.levels.WARN)
    return
  end

  -- Rewrite the ** Notes section in the buffer
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local section_start, section_end = nil, nil
  for i, line in ipairs(buf_lines) do
    if line:match("^%*%*%s+Notes") then
      section_start = i
    elseif section_start and line:match("^%*%*%s+") and i > section_start then
      section_end = i - 1
      break
    end
  end

  local new_block = { "** Notes", "" }
  for _, l in ipairs(links) do
    new_block[#new_block + 1] = l
  end
  new_block[#new_block + 1] = ""

  if section_start then
    section_end = section_end or #buf_lines
    vim.api.nvim_buf_set_lines(0, section_start - 1, section_end, false, new_block)
  else
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
    vim.api.nvim_buf_set_lines(0, -1, -1, false, new_block)
  end

  vim.notify(string.format("Index [%s]: %d notes linked", tag, #links), vim.log.levels.INFO)
end

-- ── fzf-lua pickers ───────────────────────────────────────────────────────────

local fzf_helpers = {}

function fzf_helpers.find_notes()
  require("fzf-lua").files({
    cwd = notes_root(),
    prompt = "Notes ❯ ",
    fd_opts = "--type f --extension norg",
  })
end

function fzf_helpers.grep_notes()
  require("fzf-lua").live_grep({
    cwd = notes_root(),
    prompt = "Grep notes ❯ ",
    rg_opts = "--glob '*.norg' --column --line-number --no-heading --color=always",
  })
end

function fzf_helpers.find_permanent()
  require("fzf-lua").files({
    cwd = notes_root() .. "/permanent",
    prompt = "Permanent ❯ ",
    fd_opts = "--type f --extension norg",
  })
end

function fzf_helpers.find_by_tag()
  local fzf = require("fzf-lua")
  -- Step 1: collect all unique tags across all notes
  local handle = io.popen(
    "rg --glob '*.norg' --no-filename --no-line-number 'tags: \\[' "
      .. notes_root()
      .. " | grep -oP '(?<=\\[)[^\\]]+' | tr ',' '\\n' | sed 's/^[[:space:]]*//' | sort -u"
  )
  if not handle then
    return
  end
  local tags = {}
  for line in handle:lines() do
    local t = line:match("^%s*(.-)%s*$")
    if t and t ~= "" then
      tags[#tags + 1] = t
    end
  end
  handle:close()

  -- Step 2: pick a tag, then grep for files containing it
  fzf.fzf_exec(tags, {
    prompt = "Tag ❯ ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end
        fzf.live_grep({
          cwd = notes_root(),
          prompt = "Notes tagged [" .. selected[1] .. "] ❯ ",
          search = selected[1],
          rg_opts = "--glob '*.norg' --column --line-number --no-heading --color=always",
        })
      end,
    },
  })
end

function fzf_helpers.insert_link()
  require("fzf-lua").files({
    cwd = notes_root(),
    prompt = "Link to ❯ ",
    fd_opts = "--type f --extension norg",
    -- path_shorten disabled so selected[1] is the full relative path
    fzf_opts = { ["--filepath-prefix"] = false },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end
        -- trim leading/trailing whitespace first, then strip any icon prefix
        -- (icon is non-ascii, path always starts with a regular ascii letter)
        local raw = selected[1]:match("^%s*(.-)%s*$")
        raw = raw:match("[%a%.][^%s]*%.norg$") or raw
        local abs = vim.fn.fnamemodify(notes_root() .. "/" .. raw, ":p")
        local rel =
          abs:gsub(vim.pesc(vim.fn.fnamemodify(notes_root(), ":p")), ""):gsub("%.norg$", ""):match("^[/]*(.*)") -- strip any leading slash
        local title = (rel:match("([^/]+)$") or rel):gsub("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%-", ""):gsub("-", " ")
        -- Prefix with $/ to anchor to workspace root so the link works
        -- regardless of which subdirectory the current file lives in.
        -- Without this, opening from permanent/*.norg resolves permanent/foo
        -- as permanent/permanent/foo.
        local link = ("{:$/%s:}[%s]"):format(rel, title)
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line:sub(1, col) .. link .. line:sub(col + 1) })
        vim.api.nvim_win_set_cursor(0, { row, col + #link })
      end,
    },
  })
end

function fzf_helpers.find_domain_notes()
  require("fzf-lua").files({
    cwd = notes_root() .. "/projects",
    prompt = "Domain ❯ ",
    fd_opts = "--type f --extension norg --search-path domain",
  })
end

function fzf_helpers.find_area_indexes()
  require("fzf-lua").files({
    cwd = notes_root() .. "/areas",
    prompt = "Area ❯ ",
    fd_opts = "--type f --extension norg --name index.norg",
  })
end

-- ── Buffer-local maps for .norg files ────────────────────────────────────────

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NeorgFzf", { clear = true }),
  pattern = "norg",
  callback = function()
    local function map(key, fn, desc)
      vim.keymap.set("n", key, fn, { buffer = true, silent = true, desc = desc })
    end
    map("<localleader>l", fzf_helpers.insert_link, "Notes: insert link")
    map("<localleader>f", fzf_helpers.find_notes, "Notes: find note")
    map("<localleader>g", fzf_helpers.grep_notes, "Notes: grep notes")
    map("<localleader>p", fzf_helpers.find_permanent, "Notes: find permanent")
    map("<localleader>i", neorg_helpers.regenerate_index, "Notes: regenerate index")
  end,
})

-- ── Plugin spec ───────────────────────────────────────────────────────────────

return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/lua-utils.nvim",
      "pysan3/pathlib.nvim",
      "nvim-neotest/nvim-nio",
      "MunifTanjim/nui.nvim",
      "nvim-neorg/tree-sitter-norg",
      "nvim-neorg/tree-sitter-norg-meta",
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = { config = { icon_preset = "diamond" } },
        ["core.dirman"] = {
          config = {
            workspaces = {
              brain = "~/work/notes",
              -- cora = "~/work/notes/projects/cora",
              -- fleeting = "~/work/notes/fleeting",
            },
            default_workspace = "brain",
            index = "index.norg",
          },
        },
        ["core.integrations.treesitter"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = { config = { extensions = "all" } },
        ["core.journal"] = {
          config = { workspace = "fleeting", journal_folder = "." },
        },
        ["core.summary"] = {},
      },
    },
    config = function(_, opts)
      require("neorg").setup(opts)
    end,

    keys = {
      { "<leader>mi", "<cmd>Neorg index<cr>", desc = "Notes: open index" },

      -- Capture
      { "<leader>mj", neorg_helpers.journal_today, desc = "Create: today's fleeting" },
      { "<leader>my", neorg_helpers.journal_yesterday, desc = "Create: yesterday's fleeting" },
      {
        "<leader>mt",
        function()
          vim.cmd("edit " .. vim.fn.expand("~/work/notes/personal-todo.norg"))
        end,
        desc = "Create: personal TODO",
      },

      -- Creation
      { "<leader>mz", neorg_helpers.create_permanent_note, desc = "New: permanent note" },
      { "<leader>ma", neorg_helpers.create_area, desc = "New: area" },
      { "<leader>mr", neorg_helpers.create_project, desc = "New: project" },
      { "<leader>md", neorg_helpers.create_domain_note, desc = "New: domain note" },
      { "<leader>mI", neorg_helpers.regenerate_index, desc = "Notes: regenerate index" },

      -- fzf pickers
      { "<leader>mf", fzf_helpers.find_notes, desc = "Find: find note (fzf)" },
      { "<leader>mg", fzf_helpers.grep_notes, desc = "Find: grep notes (fzf)" },
      { "<leader>mp", fzf_helpers.find_permanent, desc = "Find: permanent (fzf)" },
      { "<leader>ms", fzf_helpers.find_by_tag, desc = "Find: find by tag (fzf)" },
      { "<leader>mD", fzf_helpers.find_domain_notes, desc = "Find: domain note (fzf)" },
      { "<leader>mA", fzf_helpers.find_area_indexes, desc = "Find: area index (fzf)" },
    },
  },
}
