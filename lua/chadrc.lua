local M = {}
M.base46 = {
  theme = "tundra",
  theme_toggle = { "tundra", "catppuccin" },
}
M.ui = {
  cmp = {
    icons_left = true,
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
  },
  telescope = { style = "bordered" },
}
return M
