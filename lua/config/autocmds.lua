-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

ac("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

local auto_close_filetype = {
  "lazy",
  "mason",
  "lspinfo",
  "toggleterm",
  "null-ls-info",
  "TelescopePrompt",
  "notify",
}

-- Auto close window when leaving
-- ac("BufLeave", {
--   group = ag("lazyvim_auto_close_win", { clear = true }),
--   callback = function(event)
--     local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
--
--     if vim.fn.index(auto_close_filetype, ft) ~= -1 then
--       local winids = vim.fn.win_findbuf(event.buf)
--       for _, win in pairs(winids) do
--         vim.api.nvim_win_close(win, true)
--       end
--     end
--   end,
-- })

-- Disable leader and localleader for some filetypes
ac("FileType", {
  group = ag("lazyvim_unbind_leader_key", { clear = true }),
  pattern = {
    "lazy",
    "mason",
    "lspinfo",
    "toggleterm",
    "null-ls-info",
    "neo-tree-popup",
    "TelescopePrompt",
    "notify",
    "floaterm",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf, desc = "" })
    vim.keymap.set("n", "<localleader>", "<nop>", { buffer = event.buf, desc = "" })
  end,
})

-- Delete number column on terminals
ac("TermOpen", {
  callback = function()
    vim.cmd("setlocal listchars= nonumber norelativenumber")
    vim.cmd("setlocal nospell")
  end,
})

-- Disable next line comments
ac("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Disable eslint on node_modules
ac({ "BufNewFile", "BufRead" }, {
  group = ag("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Create a dir when saving a file if it doesnt exist
ac("BufWritePre", {
  group = ag("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
