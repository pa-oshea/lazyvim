return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        group_empty_dirs = true,
      },
      git_status = {
        group_empty_dirs = true,
      },
      buffer = {
        group_empty_dirs = true,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = { winopts = { fullscreen = true } },
  },
}
