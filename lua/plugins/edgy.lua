return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      left = {
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
        },
        {
          title = "Neo-Tree Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
        {
          title = "Neo-Tree Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        "neo-tree",
      },
      -- right = {
      --   {
      --     title = "Symbols",
      --     ft = "trouble",
      --     pinned = true,
      --     open = "Trouble symbols",
      --   },
      --   {
      --     title = "References",
      --     ft = "trouble",
      --     pinned = true,
      --     open = "Trouble lsp_references",
      --   },
      -- },
    },
  },
}
