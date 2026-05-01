return {
  {
    "suliatis/jumppack",
    config = true,
  },
  {
    "oribarilan/lensline.nvim",
    tag = "2.0.0",
    event = "LspAttach",
    config = function()
      require("lensline").setup()
    end,
  },
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 65,
      },
    },
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xa", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions / refs" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      -- Insert the overseer component just before the enconding section (lualine_x)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, {
        "overseer",
      })
    end,
  },
}
