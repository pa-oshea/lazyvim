local home = os.getenv("HOME")
vim.env.PATH = home .. "/.local/share/mise/shims:" .. vim.env.PATH
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
