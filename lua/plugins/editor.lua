return {
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       group_empty_dirs = true,
  --     },
  --     git_status = {
  --       group_empty_dirs = true,
  --     },
  --     buffer = {
  --       group_empty_dirs = true,
  --     },
  --   },
  -- },
  -- {
  --   "ibhagwan/fzf-lua",
  --   opts = { winopts = { fullscreen = true } },
  -- },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("nvchad.cmp"))
    end,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
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
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
    },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 50,
        preserve_window_proportions = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = "󰈚",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
            },
            git = { unmerged = "" },
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          n = { ["q"] = require("telescope.actions").close },
        },
      },

      extensions_list = { "themes", "terms" },
      extensions = {},
    },
  },
}
