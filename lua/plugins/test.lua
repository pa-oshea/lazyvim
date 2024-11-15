return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapaters = {
        ["neotest-go"] = {},
        ["neotest-java"] = {},
        ["neotest-jest"] = {},
      },
    },
  },
}
