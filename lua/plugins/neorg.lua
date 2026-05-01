-- Helper functions defined locally so they don't leak into the plugin spec
local function notes_root()
  return vim.fn.expand("~/work/notes")
end

-- Define functions locally
local fzf_helpers = {
  find_notes = function()
    require("fzf-lua").files({
      cwd = notes_root(),
      prompt = "Notes ❯ ",
      fd_opts = "--type f --extension norg",
      formatter = "path.filename_first",
    })
  end,
  grep_notes = function()
    require("fzf-lua").live_grep({
      cwd = notes_root(),
      prompt = "Grep notes ❯ ",
      rg_opts = "--glob '*.norg' --column --line-number --no-heading --color=always",
    })
  end,
  find_permanent = function()
    require("fzf-lua").files({
      cwd = notes_root() .. "/permanent",
      prompt = "Permanent ❯ ",
      fd_opts = "--type f --extension norg",
      formatter = "path.filename_first",
    })
  end,
  find_by_tag = function()
    require("fzf-lua").grep({
      cwd = notes_root(),
      search = "tags:.*\\S",
      rg_opts = "--glob '*.norg' --no-heading --color=always",
      prompt = "Tags ❯ ",
    })
  end,
  insert_link = function()
    require("fzf-lua").files({
      cwd = notes_root(),
      prompt = "Link to ❯ ",
      fd_opts = "--type f --extension norg",
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then
            return
          end
          local abs = selected[1]
          local root = notes_root()
          local rel = abs:gsub(vim.pesc(root) .. "/", ""):gsub("%.norg$", "")
          local title = (rel:match("([^/]+)$") or rel):gsub("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%-", ""):gsub("-", " ")
          local link = ("{:%s:}[%s]"):format(rel, title)
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line:sub(1, col) .. link .. line:sub(col + 1) })
          vim.api.nvim_win_set_cursor(0, { row, col + #link })
        end,
      },
    })
  end,
}

-- Autocmd for buffer-local maps
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NeorgFzf", { clear = true }),
  pattern = "norg",
  callback = function()
    local o = { buffer = true, silent = true }
    vim.keymap.set("n", "<localleader>l", fzf_helpers.insert_link, { buffer = true, desc = "Notes: insert link" })
    vim.keymap.set("n", "<localleader>f", fzf_helpers.find_notes, { buffer = true, desc = "Notes: find note" })
    vim.keymap.set("n", "<localleader>g", fzf_helpers.grep_notes, { buffer = true, desc = "Notes: grep notes" })
    vim.keymap.set("n", "<localleader>p", fzf_helpers.find_permanent, { buffer = true, desc = "Notes: find permanent" })
  end,
})

-- The Plugin Spec
return {
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = true,
    dependencies = {
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
              cora = "~/work/notes/projects/cora",
              fleeting = "~/work/notes/fleeting",
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
    keys = {
      { "<leader>mw", "<cmd>Neorg workspace brain<cr>", desc = "Notes: brain workspace" },
      { "<leader>mc", "<cmd>Neorg workspace cora<cr>", desc = "Notes: CORA workspace" },
      { "<leader>mi", "<cmd>Neorg index<cr>", desc = "Notes: open index" },
      { "<leader>mj", "<cmd>Neorg journal today<cr>", desc = "Notes: today's fleeting" },
      { "<leader>mf", fzf_helpers.find_notes, desc = "Notes: find note (fzf)" },
      { "<leader>mg", fzf_helpers.grep_notes, desc = "Notes: grep notes (fzf)" },
      { "<leader>mp", fzf_helpers.find_permanent, desc = "Notes: find permanent (fzf)" },
      { "<leader>ms", fzf_helpers.find_by_tag, desc = "Notes: find by tag (fzf)" },
      -- New Permanent Note Logic
      {
        "<leader>mz",
        desc = "Notes: new permanent ZK note",
        callback = function()
          local id = os.date("%Y%m%d%H%M%S")
          local title = vim.fn.input("Note title: ")
          if title == "" then
            return
          end
          local slug = title:lower():gsub("%s+", "-"):gsub("[^a-z0-9%-]", "")
          local path = vim.fn.expand("~/notes/permanent/") .. id .. "-" .. slug .. ".norg"
          vim.cmd("edit " .. vim.fn.fnameescape(path))
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "@document.meta",
            "title: " .. title,
            "id: " .. id,
            "tags: []",
            "created: " .. os.date("%Y-%m-%d"),
            "@end",
            "",
            "* " .. title,
            "",
            "** Summary",
            "",
            "** Detail",
            "",
            "** Connections",
            "",
            "** References",
          })
          vim.cmd("normal! 11G$")
        end,
      },
    },
  },
}
