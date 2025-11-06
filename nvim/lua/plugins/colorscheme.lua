return {
  {
    "rebelot/kanagawa.nvim",
    opts = {
      transparent = true,
      theme = "wave",
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
              bg_p1 = "none", --lualine
              float = "none",
            },
          },
        },
      },
      overrides = function()
        return {
          -- Assign a static color to strings
          -- String = { fg = colors.palette.carpYellow, italic = true },
          -- theme colors will update dynamically when you change theme!
          CodeBlock = { bg = "#1a1c2a" },
          CursorLine = { bg = "none" },
        }
      end,
    },
  },
  {
    "Mofiqul/dracula.nvim",
    opts = {
      lualine_bg_color = "#44475a", -- default nil
      transparent_bg = true, -- default false

      overrides = {
        CursorLine = { bg = "none" },
        SnacksPickerFile = { fg = "white" },
        SnacksPickerDir = { fg = "white" },
        SnacksPickerComment = { fg = "white" },
        SnacksPickerLabel = { fg = "white" },
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      transparent_background = true,
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      -- no_italic = true,
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      custom_highlights = function(colors)
        return {
          CursorLine = { bg = colors.none },
          DapStoppedLine = { bg = "#1e1e2e" },
        }
      end,
    },
  },
  {
    "tokyonight.nvim",
    priority = 1000,
    opts = function()
      return {
        style = "night",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_colors = function(colors)
          colors.bg_statusline = colors.none -- transparent lualine/
        end,
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.CursorLine = { bg = "none" }
          -- hl.RenderMarkdownCode = { bg = "#2E2E2E" }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          hl.NeoTreeGitModified = { fg = c.orange }
          hl.DiagnosticUnnecessary = { fg = "#918fbb" } -- unused variables etc
        end,
      }
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      dark_variant = "moon",
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,
      highlight_groups = {
        Comment = { italic = true },
        FloatBorder = { fg = "subtle", bg = "none" },
        ColorColumn = { bg = "rose" },
        MiniIndentscopeSymbol = { fg = "rose" },
        -- StatusLine = { fg = "love", bg = "love", blend = 10 },
        -- StatusLineNC = { fg = "subtle", bg = "surface" },
        StatusLine = { bg = "none" },
        StatusLineNC = { bg = "none" },
        GitSignsAdd = { fg = "iris", bg = "none" },
        GitSignsChange = { fg = "foam", bg = "none" },
        GitSignsDelete = { fg = "rose", bg = "none" },
        CursorLine = { bg = "none" },
        Cursor = { fg = "#000000", bg = "#e0def4" },
      },
    },
  },
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "deep", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = true, -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      code_style = {
        comments = "italic",
        keywords = "bold",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      lualine = {
        transparent = true, -- lualine center bar transparency
      },

      colors = {},
      highlights = {
        StatusLine = { bg = "none" },
        NormalFloat = { bg = "none" },
        WinBar = { bg = "none" },
        WinBarNC = { bg = "none" },
        DapStoppedLine = { bg = "#1e1e2e" },
        -- DiagnosticWarn = { bg = "#1e1e2e" },
        DiagnosticWarn = { bg = "none" },
        CursorLine = { bg = "none" },
        CodeBlock = { bg = "#1e1e2e" },
        MatchParen = { bg = "none", fg = "#f7768e" },
        FloatBorder = { bg = "none" },
      },

      -- Plugins Config --
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = false, -- use background color for virtual text
      },
    },
  },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        style = "multiplex", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
        transparent = true, -- Show/hide background
        lualine = {
          transparent = true, -- lualine center bar transparency
        },
        highlights = {
          DiagnosticVirtualTextHint = { bg = "none" },
          DiagnosticVirtualTextWarn = { bg = "none" },
          DiagnosticVirtualTextError = { bg = "none" },
          DiagnosticVirtualTextInformation = { bg = "none" },
          CursorLine = { bg = "none" },
          -- IblIndent = { fg = "#333333" },
          -- CodeBlock = { bg = "#1a1c2a" },
        },
      })
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    loadfile = true,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        terminal_colors = true,
        variant = "default",
        highlights = {
          CursorColumn = { bg = "none" },
          FoldColumn = { bg = "none" },
          IblIndent = { fg = "#333333" },
          CodeBlock = { bg = "#1e1e2e" },
          CursorLine = { bg = "none" },
        },
      })
    end,
  },
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("eldritch").setup({
        palette = "darker",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        hide_inactive_statusline = true,
        on_highlights = function(highlights, colors)
          -- highlights.WinBar = { bg = colors.none }
          -- highlights.WinBarNC = { bg = colors.none }
          highlights.CodeBlock = { bg = "#040404" }
          highlights.CursorLine = { bg = colors.none }
          highlights.LspInlayHint = { bg = colors.none, fg = "#7081d0" }
          highlights.StatusLine = { bg = colors.bg_highlight }
          highlights.StatusLineNC = { bg = colors.bg_highlight }
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "bamboo",
    },
  },
}
