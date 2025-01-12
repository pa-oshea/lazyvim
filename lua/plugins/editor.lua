return {
  {
    "stevearc/oil.nvim",
    opts = {
      delete_to_trash = true,
      float = {
        max_height = 45,
        max_width = 90,
      },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
  -- stylua: ignore
  keys = {
    { "<leader>;", function() require("oil").toggle_float() end, desc = "Toggle Oil" },
  },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = { enabled = false },
      },
    },
  },
  {
    "mbbill/undotree",
    cmd = { "Undotree", "UndotreeToggle" },
    keys = {
      {
        "<leader>v",
        function()
          vim.cmd("UndotreeToggle")
        end,
        desc = "Undo tree",
      },
    },
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
    config = true,
  },
}
