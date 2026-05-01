return {
  {
    "stevearc/overseer.nvim",
    opts = {
      -- Pin the task list to the bottom, same feels as a terminal pane
      task_list = {
        direction = "bottom",
        min_height = 18,
        max_height = 18,
        default_detail = 1,
      },

      -- Neotest integration
      -- When neotest runs a test, it creates an overseer task so the result appears in the task list alongside running services.
      component_aliases = {
        default_neotest = {
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
      },
    },

    config = function(_, opts)
      require("overseer").setup(opts)
    end,
  },
}
