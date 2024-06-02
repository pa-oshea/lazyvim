return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
        },
      },
    },
    pickers = {
      diagnostics = {
        theme = "ivy",
      },
      lsp_document_symbols = {
        theme = "ivy",
      },
      lsp_workspace_symbols = {
        theme = "ivy",
      },
      lsp_dynamic_workspace_symbols = {
        theme = "ivy",
      },
    },
  },
}
