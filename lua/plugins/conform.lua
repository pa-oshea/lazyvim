return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
      lua = { "stylua" },
      sh = { "shfmt" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      dockerfile = { "hadolint" },
    },
  },
}
