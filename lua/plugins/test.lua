return {
  { "rcasia/neotest-java", pin = true },
  {
    "nvim-neotest/neotest",
    opts = {
      adapaters = {
        ["neotest-java"] = {
          ignore_patterns = { ".git", "node_modules", "target", "build" },
          maven = {
            download_dependencies = true,
            force_maven_wrapper = false,
          },
        },
      },
    },

    consumers = {
      overseer = require("neotest.consumers.overseer"),
    },
  },

  keys = {
    {
      "<leader>tF",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File (Neotest)",
    },
    {
      "<leader>tA",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files (Neotest)",
    },
    {
      "<leader>tn",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest (Neotest)",
    },
    {
      "<leader>tm",
      function()
        require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
      end,
      desc = "Run file tests with DAP (Neotest)",
    },
  },

  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "Coverage", "CoverageSummary", "CoverageToggle" },
    keys = {
      { "<leader>tc", "<cmd>CoverageToggle<cr>", desc = "Toggle coverage" },
      { "<leader>tC", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
    },
  },
}
