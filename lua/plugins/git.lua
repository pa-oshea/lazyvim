return {
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
    keys = {
      {
        "<leader>gdo",
        function()
          vim.cmd("DiffviewOpen")
        end,
        desc = "Open diff view",
      },
      {
        "<leader>gdc",
        function()
          vim.cmd("DiffviewClose")
        end,
        desc = "Close diff view",
      },
      {
        "<leader>gdf",
        function()
          vim.cmd("DiffviewFileHistory")
        end,
        desc = "File history (All commits)",
      },
      {
        "<leader>gdd",
        function()
          vim.cmd("DiffviewFileHistory %")
        end,
        desc = "File history (Current file)",
      },
    },
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    key = {
      {
        "<leader>go",
        function()
          require("neogit").open()
        end,
        desc = "Neogit",
      },
    },
    config = true,
  },
}
