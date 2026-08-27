return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      { "akinsho/org-bullets.nvim" }, -- nicer heading bullets, Neorg-like feel
      { "nvim-orgmode/org-bullets.nvim" }, -- (use whichever fork you prefer; akinsho's is common)
    },
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/work/notes/**/*.org",
        org_default_notes_file = "~/work/notes/fleeting/refile.org",

        org_todo_keywords = { "TODO", "NEXT", "WAITING", "|", "DONE", "CANCELLED" },
        org_todo_keyword_faces = {
          TODO = ":foreground #ff8080",
          NEXT = ":foreground #ffcc66",
          WAITING = ":foreground #999999",
          DONE = ":foreground #88cc88",
        },

        org_capture_templates = {
          f = {
            description = "Fleeting note",
            template = "* %?\n  %U",
            target = "~/work/notes/fleeting/%<%Y%m%d%H%M%S>-fleeting.org",
          },
          p = {
            description = "Permanent note",
            template = "* %?\n  %U",
            target = "~/work/notes/permanent/%<%Y%m%d%H%M%S>-permanent.org",
          },
          a = {
            description = "Area note",
            template = "* %?\n  %U",
            target = "~/work/notes/areas/%<%Y%m%d%H%M%S>-area.org",
          },
          j = {
            description = "Project note",
            template = "* %?\n  %U",
            target = "~/work/notes/projects/%<%Y%m%d%H%M%S>-project.org",
          },
          t = {
            description = "TODO",
            template = "* TODO %?\n  %U",
            target = "~/work/notes/fleeting/refile.org",
          },
        },

        org_agenda_span = "week",
        org_agenda_start_on_weekday = 1,
        win_split_mode = "horizontal",

        -- Fold like Neorg's collapsed headings by default
        org_startup_folded = "overview",
      })

      require("org-bullets").setup({
        symbols = { "◉", "○", "✸", "✿" },
      })
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    dependencies = { "nvim-orgmode/orgmode" },
    config = function()
      require("org-roam").setup({
        directory = "~/work/notes",
        org_files = { "~/work/notes/**/*.org" },
      })
    end,
  },
}
