return {
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
}
