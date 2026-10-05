-- orgmode is scoped to TODOs/agenda only — Zettelkasten-style note taking
-- (permanent/fleeting/project notes, backlinks) lives in obsidian.nvim
-- (see obsidian.lua) so there's no overlap between the two plugins.
return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      { "akinsho/org-bullets.nvim" }, -- nicer heading bullets
    },
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/work/org-notes/**/*.org",
        org_default_notes_file = "~/work/org-notes/refile.org",

        org_todo_keywords = { "TODO", "NEXT", "WAITING", "|", "DONE", "CANCELLED" },
        org_todo_keyword_faces = {
          TODO = ":foreground #ff8080",
          NEXT = ":foreground #ffcc66",
          WAITING = ":foreground #999999",
          DONE = ":foreground #88cc88",
        },

        org_capture_templates = {
          t = {
            description = "TODO",
            template = "* TODO %?\n  %U",
            target = "~/work/org-notes/refile.org",
          },
          m = {
            description = "Meeting",
            template = "* MEETING %? :meeting:\n  %U",
            target = "~/work/org-notes/refile.org",
          },
        },

        org_agenda_span = "week",
        org_agenda_start_on_weekday = 1,
        win_split_mode = "horizontal",

        -- Fold headings by default
        org_startup_folded = "overview",

        -- ── Keymaps ─────────────────────────────────────────────────────────
        -- Global entry points live under <leader>o alongside overseer.nvim's
        -- <leader>oo/<leader>ot/<leader>ow — "a" and "c" are free there, so no
        -- collisions. Everything else (TODO cycling, schedule, clock, etc.) is
        -- orgmode's own buffer-local defaults and only applies in *.org files.
        mappings = {
          global = {
            org_agenda = "<leader>oa",
            org_capture = "<leader>oc",
          },
        },
      })

      require("org-bullets").setup({
        symbols = { "◉", "○", "✸", "✿" },
      })
    end,
  },
}
