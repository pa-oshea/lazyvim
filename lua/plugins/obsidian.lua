-- ~/.config/nvim/lua/plugins/obsidian.lua
--
-- Uses the actively maintained community fork: obsidian-nvim/obsidian.nvim
-- Companion plugins:
--   - render-markdown.nvim  (replaces obsidian.nvim's own UI — better concealing)
--   - markdown-preview.nvim (browser preview with live Mermaid rendering)
--
-- Vault layout assumed:
--   ~/work/notes/
--     permanent/      ← pattern notes, concept notes
--     fleeting/       ← quick captures, inbox
--     projects/       ← project-specific context (e.g. cora/)
--     daily/          ← daily notes
--     templates/      ← note templates

return {
  {
    "iamcco/markdown-preview.nvim",
    build = function() end, -- replace the build hook with a no-op
    cmd = {}, -- remove command registrations so nothing conflicts
    enabled = false, -- belt and braces
  },
  -- ── render-markdown.nvim ────────────────────────────────────────────────
  -- Replaces obsidian.nvim's built-in UI. Better concealing, callout support,
  -- renders headings with icons, styles code blocks with language badges.
  -- Must load BEFORE obsidian.nvim so we can disable obsidian's own UI.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      -- Use the obsidian preset — mirrors Obsidian app visual conventions
      preset = "obsidian",

      -- Render in normal, command, and terminal modes
      render_modes = { "n", "c", "t" },

      -- Heading icons per level — requires a Nerd Font
      heading = {
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },

      -- Code blocks: show language name + icon
      code = {
        sign = true,
        width = "block",
        right_pad = 1,
      },

      -- Callouts — GitHub and Obsidian style both work
      -- [!NOTE], [!TIP], [!WARNING], [!IMPORTANT], [!CAUTION]
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },

      -- Bullet point icons per list depth
      bullet = {
        icons = { "●", "○", "◆", "◇" },
      },
    },
  },

  -- ── markdown-preview.nvim ────────────────────────────────────────────────
  -- Browser preview with live Mermaid diagram rendering.
  -- :MarkdownPreview opens a browser tab; updates on save with scroll sync.
  -- Zero npm dependencies — pure Lua + browser CDN.
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    enabled = true,
    ft = { "markdown" },
    config = function()
      require("markdown_preview").setup({
        instance_mode = "takeover", -- one browser tab, reused on each preview
        port = 0, -- 0 = auto-assign
        open_browser = true,
        debounce_ms = 300,
      })
    end,
    keys = {
      { "<leader>ap", "<cmd>MarkdownPreview<cr>", ft = "markdown", desc = "Markdown Preview" },
      { "<leader>aP", "<cmd>MarkdownPreviewStop<cr>", ft = "markdown", desc = "Markdown Preview Stop" },
    },
  },

  -- ── obsidian.nvim ────────────────────────────────────────────────────────
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/work/notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/work/notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },

    opts = {
      -- Disable legacy ObsidianXxx commands — use `Obsidian xxx` style instead
      legacy_commands = false,

      -- Disable obsidian's built-in UI — render-markdown.nvim handles this
      ui = { enable = false },

      -- ── Workspaces ──────────────────────────────────────────────────────
      workspaces = {
        {
          name = "work",
          path = "~/work/notes",
        },
        -- Uncomment when starting a masters vault:
        -- {
        --   name = "masters",
        --   path = "~/masters/notes",
        -- },
      },

      -- ── Note ID / filename convention ────────────────────────────────────
      -- Preserves the existing timestamp-slug format:
      -- e.g. 20260503000001-proxy-pattern.md
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^a-zA-Z0-9-]", ""):lower()
        else
          for _ = 1, 8 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- ── Frontmatter ─────────────────────────────────────────────────────
      -- Uses frontmatter.func (replaces deprecated note_frontmatter_func).
      -- Sorts properties with id, aliases, tags first — matches Obsidian app defaults.
      frontmatter = {
        func = function(note)
          local out = {
            id = note.id,
            aliases = note.aliases,
            tags = note.tags,
            description = note.metadata and note.metadata.description or "",
            created = os.date("%Y-%m-%d"),
          }
          -- Preserve any existing custom metadata fields
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              if out[k] == nil then
                out[k] = v
              end
            end
          end
          return out
        end,
        sort = { "id", "aliases", "tags", "description", "created" },
      },

      -- ── Folder layout ───────────────────────────────────────────────────
      notes_subdir = "permanent",
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily.md",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- ── Links ───────────────────────────────────────────────────────────
      -- Replaces deprecated wiki_link_func and preferred_link_style.
      -- style = "wiki"  → [[wikilinks]] — understood by Obsidian app and mobile
      -- format = "shortest" → uses basename without path (default, matches Obsidian)
      -- auto_update = true → renames update all [[links]] across the vault via LSP
      link = {
        style = "wiki",
        format = "shortest",
        auto_update = true,
      },

      -- ── Completion ──────────────────────────────────────────────────────
      completion = {
        min_chars = 2,
        blink = { enabled = true }, -- if using blink.cmp (LazyVim default)
        -- nvim_cmp = true,            -- uncomment if using nvim-cmp instead
      },

      -- ── Picker ──────────────────────────────────────────────────────────
      picker = {
        name = "fzf-lua",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },
    },

    -- ── Keymaps ─────────────────────────────────────────────────────────────
    -- Mappings config option is removed in the fork — define keymaps here instead.
    -- Uses new `Obsidian <subcommand>` style (legacy_commands = false).
    keys = {
      -- Follow link under cursor (gf passthrough — works on [[links]] and file paths)
      {
        "gf",
        function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>Obsidian follow_link<cr>"
          else
            return "gf"
          end
        end,
        expr = true,
        noremap = false,
        desc = "Follow link or gf",
      },

      -- Navigation
      { "<leader>an", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>ao", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
      { "<leader>as", "<cmd>Obsidian search<cr>", desc = "Search vault" },
      { "<leader>ab", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>at", "<cmd>Obsidian tags<cr>", desc = "Browse tags" },
      { "<leader>al", "<cmd>Obsidian links<cr>", desc = "Links in note" },
      { "<leader>aT", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },

      -- Daily notes
      { "<leader>ad", "<cmd>Obsidian today<cr>", desc = "Today's note" },
      { "<leader>ay", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's note" },

      -- Templates & creation
      { "<leader>aN", "<cmd>Obsidian new_from_template<cr>", desc = "New from template" },

      -- Rename (LSP rename — updates all [[links]] across vault)
      { "<leader>ar", "<cmd>Obsidian rename<cr>", desc = "Rename note" },

      -- Open current note in Obsidian app (graph view, mobile preview)
      { "<leader>aO", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },

      -- Toggle checkbox on current line
      { "<leader>ac", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },

      -- Paste image from clipboard (requires xclip/wl-clipboard on Linux)
      { "<leader>ai", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
    },
  },
}
