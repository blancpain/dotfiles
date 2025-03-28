return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   opts = {
  --     transparent = true,
  --     theme = "wave",
  --     colors = {
  --       theme = {
  --         all = {
  --           ui = {
  --             bg_gutter = "none",
  --             bg_p1 = "none", --lualine
  --             float = "none",
  --           },
  --         },
  --       },
  --     },
  --     overrides = function(colors)
  --       return {
  --         -- Assign a static color to strings
  --         -- String = { fg = colors.palette.carpYellow, italic = true },
  --         -- theme colors will update dynamically when you change theme!
  --         CodeBlock = { bg = "#1a1c2a" },
  --       }
  --     end,
  --   },
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
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
          -- CursorLine = { bg = colors.none },
          NavicText = { bg = colors.none, fg = colors.flamingo },
          NavicSeparator = { bg = colors.none },
          NavicIconsKey = { bg = colors.none },
          NavicIconsEnum = { bg = colors.none },
          NavicIconsFile = { bg = colors.none },
          NavicIconsNull = { bg = colors.none },
          NavicIconsArray = { bg = colors.none },
          NavicIconsClass = { bg = colors.none },
          NavicIconsEvent = { bg = colors.none },
          NavicIconsField = { bg = colors.none },
          NavicIconsMethod = { bg = colors.none },
          NavicIconsModule = { bg = colors.none },
          NavicIconsNumber = { bg = colors.none },
          NavicIconsObject = { bg = colors.none },
          NavicIconsString = { bg = colors.none },
          NavicIconsStruct = { bg = colors.none },
          NavicIconsBoolean = { bg = colors.none },
          NavicIconsPackage = { bg = colors.none },
          NavicIconsConstant = { bg = colors.none },
          NavicIconsFunction = { bg = colors.none },
          NavicIconsOperator = { bg = colors.none },
          NavicIconsProperty = { bg = colors.none },
          NavicIconsVariable = { bg = colors.none },
          NavicIconsInterface = { bg = colors.none },
          NavicIconsNamespace = { bg = colors.none },
          NavicIconsEnumMember = { bg = colors.none },
          NavicIconsConstructor = { bg = colors.none },
          NavicIconsTypeParameter = { bg = colors.none },
          CursorLine = { bg = colors.none },
          DapStoppedLine = { bg = "#1e1e2e" },
        }
      end,
      -- color_overrides = {
      --   mocha = {
      --     rosewater = "#efc9c2",
      --     flamingo = "#ebb2b2",
      --     pink = "#f2a7de",
      --     mauve = "#b889f4",
      --     red = "#ea7183",
      --     maroon = "#ea838c",
      --     peach = "#f39967",
      --     yellow = "#eaca89",
      --     green = "#96d382",
      --     teal = "#78cec1",
      --     sky = "#91d7e3",
      --     sapphire = "#68bae0",
      --     blue = "#739df2",
      --     lavender = "#a0a8f6",
      --     text = "#b5c1f1",
      --     subtext1 = "#a6b0d8",
      --     subtext0 = "#959ec2",
      --     overlay2 = "#848cad",
      --     overlay1 = "#717997",
      --     overlay0 = "#63677f",
      --     surface2 = "#505469",
      --     surface1 = "#3e4255",
      --     surface0 = "#2c2f40",
      --     base = "#1a1c2a",
      --     mantle = "#141620",
      --     crust = "#0e0f16",
      --   },
      -- },
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
          colors.bg_statusline = colors.none -- transparent lualine/navic/
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
        -- CursorLine = { bg = "none" },
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
  -- {
  --   "zootedb0t/citruszest.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     option = {
  --       transparent = true,
  --       bold = true,
  --       italic = true,
  --     },
  --     style = {
  --       IblIndent = { fg = "#333333" },
  --       TreesitterContextLineNumber = { bg = "none" },
  --       StatusLine = { bg = "none" },
  --       ColorColumn = { bg = "#1e1e2e" },
  --     },
  --   },
  -- },
  -- {
  --   "ribru17/bamboo.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("bamboo").setup({
  --       style = "multiplex", -- Choose between 'vulgaris' (regular), 'multiplex' (greener), and 'light'
  --       transparent = false, -- Show/hide background
  --       lualine = {
  --         transparent = true, -- lualine center bar transparency
  --       },
  --       highlights = {
  --         DiagnosticVirtualTextHint = { bg = "none" },
  --         DiagnosticVirtualTextWarn = { bg = "none" },
  --         DiagnosticVirtualTextError = { bg = "none" },
  --         DiagnosticVirtualTextInformation = { bg = "none" },
  --         -- IblIndent = { fg = "#333333" },
  --         -- CodeBlock = { bg = "#1a1c2a" },
  --       },
  --     })
  --   end,
  -- },
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
        variant = "dark",
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
  -- { "diegoulloao/neofusion.nvim", priority = 1000, config = true, opts = {} },
  -- {
  --   "samharju/synthweave.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000,
  --   config = function()
  --     local synthweave = require("synthweave")
  --     synthweave.setup({
  --       transparent = false,
  --       overrides = {
  --         -- Identifier = { fg = "#f22f52" },
  --       },
  --       palette = {
  --         -- override palette colors, take a peek at synthweave/palette.lua
  --         -- bg0 = "#040404",
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- Optional; default configuration will be used if setup isn't called.
  --   config = function()
  --     require("everforest").setup({
  --       -- Your config here
  --       background = "soft",
  --       transparent_background_level = 2,
  --       on_highlights = function(hl, palette)
  --         -- hl.CursorLine = { bg = palette.none }
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --   "polirritmico/monokai-nightasty.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     dark_style_background = "default", -- default, dark, transparent, #color
  --     light_style_background = "default", -- default, dark, transparent, #color
  --     color_headers = true, -- Enable header colors for each header level (h1, h2, etc.)
  --     lualine_bold = true, -- Lualine a and z sections font width
  --     lualine_style = "default", -- "dark", "light" or "default" (Follows dark/light style)
  --     markdown_header_marks = true, -- Add headers marks highlights (the `#` character) to Treesitter highlight query
  --     -- Style to be applied to different syntax groups. See `:help nvim_set_hl`
  --     hl_styles = {
  --       keywords = { italic = true },
  --       comments = { italic = true },
  --     },
  --
  --     -- This also could be a table like this: `terminal_colors = { Normal = { fg = "#e6e6e6" } }`
  --     terminal_colors = function(colors)
  --       return { fg = colors.fg_dark }
  --     end,
  --
  --     --- You can override specific color/highlights. Theme color values
  --     --- in `extras/palettes`. Also could be any hex RGB color you like.
  --     on_colors = function(colors)
  --       -- Custom color only for light theme
  --       local current_is_light = vim.o.background == "light"
  --       colors.comment = current_is_light and "#2d7e79" or colors.grey
  --
  --       -- Custom color only for dark theme
  --       colors.border = not current_is_light and colors.magenta or colors.border
  --
  --       -- Custom lualine normal color
  --       colors.lualine.normal_bg = current_is_light and "#7ebd00" or colors.green
  --     end,
  --
  --     on_highlights = function(highlights, colors)
  --       -- You could add styles like bold, underline, italic
  --       highlights.TelescopeSelection = { bold = true }
  --       highlights.TelescopeBorder = { fg = colors.grey }
  --       highlights["@lsp.type.property.lua"] = { fg = colors.fg }
  --     end,
  --   },
  --   config = function(_, opts)
  --     -- Highlight line at the cursor position
  --     vim.opt.cursorline = true
  --
  --     -- Default to dark theme
  --     vim.o.background = "light" -- dark | light
  --
  --     require("monokai-nightasty").load(opts)
  --   end,
  -- },
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,

    config = function()
      -- Default options
      require("modus-themes").setup({
        -- Theme comes in two styles `modus_operandi` and `modus_vivendi`
        -- `auto` will automatically set style based on background set with vim.o.background
        style = "auto",
        variant = "default", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
        transparent = true, -- Transparent background (as supported by the terminal)
        dim_inactive = false, -- "non-current" windows are dimmed
        hide_inactive_statusline = false, -- Hide statuslines on inactive windows. Works with the standard **StatusLine**, **LuaLine** and **mini.statusline**
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },

        --- You can override specific color groups to use other groups or a hex color
        --- Function will be called with a ColorScheme table
        --- Refer to `extras/lua/modus_operandi.lua` or `extras/lua/modus_vivendi.lua` for the ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors) end,

        --- You can override specific highlights to use other groups or a hex color
        --- Function will be called with a Highlights and ColorScheme table
        --- Refer to `extras/lua/modus_operandi.lua` or `extras/lua/modus_vivendi.lua` for the Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
          highlights.NormalFloat = { bg = "none" }
          highlights.CursorLine = { bg = "none" }
          highlights.LineNrAbove = { bg = "none" }
          highlights.LineNrBelow = { bg = "none" }
          highlights.StatusLineNC = { bg = "none" }
          highlights.StatusLine = { bg = "none" }
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
