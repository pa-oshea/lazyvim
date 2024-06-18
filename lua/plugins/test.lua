local keymaps = function() end

return {
  {
    "rcasia/neotest-java",
    tag = "v0.10.0",
    ft = "java",
    dependencies = {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
    keys = {
      { "<leader>tn", "", desc = "+neotest" },
      {
        "<leader>tnt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tnT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tnr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tnl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>tns",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>tno",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tnO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tnS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>tnw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toggle Watch",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
          }),
        },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd("copen")
          end,
        },
      })

      -- vim.keymap.set("n", "<leader>tp", function()
      --   require("neotest").run.run(vim.uv.cwd())
      -- end, { desc = "[T]est [P]project", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>tf", function()
      --   require("neotest").run.run(vim.fn.expand("%"))
      -- end, { desc = "[T]est [F]ile", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>tr", function()
      --   require("neotest").run.run()
      -- end, { desc = "[T]est [R]un", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>tS", function()
      --   require("neotest").run.stop()
      -- end, { desc = "[T]est [S]top", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>ta", function()
      --   require("neotest").run.attach()
      -- end, { desc = "[T]est [A]ttach", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>ts", function()
      --   require("neotest").summary.open()
      -- end, { desc = "[T]est [S]ummary", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>to", function()
      --   require("neotest").output.open()
      -- end, { desc = "[T]est output [O]pen", noremap = true })
      --
      -- vim.keymap.set("n", "<leader>tO", function()
      --   require("neotest").output_panel.open()
      -- end, { desc = "[T]est output panel [O]pen", noremap = true })
    end,
  },
  {
    "rcasia/neotest-java",
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapaters = {
        "neotest-go",
        "neotest-java",
        "neotest-jest",
      },
    },
  },
}
