-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
-- clipboard ---------------------------------------------------------------
map("n", "<C-y>", '"+y<ese>', { desc = "Copy to cliboard" })
map("x", "<C-y>", '"+y<ese>', { desc = "Copy to cliboard" })
map("n", "<C-p>", '"+p<esc>', { desc = "Paste from clipboard" })

-- Make 'c' key not copy to clipboard when changing a character.
map("n", "c", '"_c', { desc = "Change without yanking" })
map("n", "C", '"_C', { desc = "Change without yanking" })
map("x", "c", '"_c', { desc = "Change without yanking" })
map("x", "C", '"_C', { desc = "Change without yanking" })

-- Make 'x' key not copy to clipboard when deleting a character.
map("n", "x", function()
  -- Also let's allow 'x' key to delete blank lines in normal mode.
  if vim.fn.col(".") == 1 then
    local line = vim.fn.getline(".")
    if line:match("^%s*$") then
      vim.api.nvim_feedkeys('"_dd', "n", false)
      vim.api.nvim_feedkeys("$", "n", false)
    else
      vim.api.nvim_feedkeys('"_x', "n", false)
    end
  else
    vim.api.nvim_feedkeys('"_x', "n", false)
  end
end, { desc = "Delete character without yanking it" })
map("x", "x", '"_x', { desc = "Delete all characters in line" })

-- Same for shifted X
map("n", "X", function()
  -- Also let's allow 'x' key to delete blank lines in normal mode.
  if vim.fn.col(".") == 1 then
    local line = vim.fn.getline(".")
    if line:match("^%s*$") then
      vim.api.nvim_feedkeys('"_dd', "n", false)
      vim.api.nvim_feedkeys("$", "n", false)
    else
      vim.api.nvim_feedkeys('"_x', "n", false)
    end
  else
    vim.api.nvim_feedkeys('"_x', "n", false)
  end
end, { desc = "Delete character without yanking it" })
map("x", "X", '"_x', { desc = "Delete all characters in line" })

-- Override nvim default behavior so it doesn't auto-yank when pasting on visual mode.
map("x", "p", "P", { desc = "Paste content you've previourly yanked" })
map("x", "P", "p", { desc = "Yank what you are going to override, then paste" })
