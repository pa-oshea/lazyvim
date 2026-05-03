return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  -- Load only when opening Markdown files in your notes directory
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "brain",
        path = "~/work/notes",
      },
    },

    -- Match your existing Neorg fleeting path: fleeting/YYYY/MM/DD.md
    daily_notes = {
      folder = "fleeting/" .. os.date("%Y/%m"),
      date_format = "%d",
      template = "fleeting.md",
    },

    -- Match your existing Zettelkasten ID format: 20260502125106-title.md[cite: 1, 3]
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.date("%Y%m%d%H%M%S")) .. "-" .. suffix
    end,

    -- Standard Zettelkasten directory for new notes created via Obsidian[cite: 1, 3]
    notes_subdir = "permanent",

    -- Completion settings
    completion = {
      blink = true, -- Enable blink.cmp
      nvim_cmp = false, -- Disable nvim-cmp
      min_chars = 2,
      create_new = true,
    },

    -- Map Obsidian concepts to your folder structure
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    -- Use standard WikiLinks [[Link]] for Markdown portability
    preferred_link_style = "wiki",

    -- Customize how the UI looks in Neovim
    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
      },
    },
  },
}
