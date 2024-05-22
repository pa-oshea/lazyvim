return {
  "nvim-lualine/lualine.nvim",
  opt = {
    winbar = {
      lualine_a = {
        {
          "filename",
          show_modified_status = true,
          use_mode_colors = true,
          symbols = {
            modified = " ●",
            alternate_file = "",
            directory = "",
          },
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {
        {
          "filename",
          show_modified_status = true,
          use_mode_colors = true,
          symbols = {
            modified = " ●",
            alternate_file = "",
            directory = "",
          },
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
