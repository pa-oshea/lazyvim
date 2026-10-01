---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  keys = {
    -- Open Yazi at current file
    {
      "<leader>;",
      "<cmd>Yazi<CR>",
      mode = { "n", "v" },
      desc = "Yazi: Current File",
    },

    -- Open Yazi in project root / cwd
    {
      "<leader>cw",
      "<cmd>Yazi cwd<CR>",
      mode = "n",
      desc = "Yazi: Working Directory",
    },

    -- Toggle last Yazi session
    {
      "<C-Up>",
      "<cmd>Yazi toggle<CR>",
      mode = "n",
      desc = "Yazi: Resume Session",
    },

    -- Open selected files in splits
    {
      "<leader>yv",
      function()
        require("yazi").yazi({
          open_for_directories = true,
        })
      end,
      desc = "Yazi: Open",
    },
  },

  opts = {
    --------------------------------------------------------------------------
    -- Replace netrw for directory editing
    --------------------------------------------------------------------------
    open_for_directories = true,

    --------------------------------------------------------------------------
    -- Floating window appearance
    --------------------------------------------------------------------------
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_border = "rounded",

    --------------------------------------------------------------------------
    -- Clipboard integration
    --------------------------------------------------------------------------
    clipboard_register = "+",

    --------------------------------------------------------------------------
    -- Better defaults
    --------------------------------------------------------------------------
    -- highlight_groups = {
    --   hovered_buffer = "Visual",
    --   hovered_split = "Visual",
    -- },

    --------------------------------------------------------------------------
    -- Internal keymaps inside Yazi
    --------------------------------------------------------------------------
    keymaps = {
      show_help = "<F1>",

      open_file_in_vertical_split = "<C-v>",
      open_file_in_horizontal_split = "<C-s>",
      open_file_in_tab = "<C-t>",

      grep_in_directory = "<C-g>",
      replace_in_directory = "<C-r>",

      cycle_open_buffers = "<Tab>",
      copy_relative_path_to_selected_files = "<C-y>",
      send_to_quickfix_list = "<C-q>",
    },
  },

  init = function()
    --------------------------------------------------------------------------
    -- Disable netrw completely
    --------------------------------------------------------------------------
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
