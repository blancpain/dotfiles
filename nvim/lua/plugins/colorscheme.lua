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
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   opts = {
  --     flavour = "mocha",
  --     transparent_background = true,
  --     -- no_italic = true,
  --     styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
  --       comments = { "italic" },
  --       conditionals = {},
  --       loops = {},
  --       functions = {},
  --       keywords = {},
  --       strings = {},
  --       variables = {},
  --       numbers = {},
  --       booleans = {},
  --       properties = {},
  --       types = {},
  --       operators = {},
  --     },
  --     custom_highlights = function(colors)
  --       return {
  --         CursorLine = { bg = colors.none },
  --         TreeSitterContextBottom = { fg = colors.none },
  --         NavicText = { bg = colors.none, fg = colors.flamingo },
  --         NavicSeparator = { bg = colors.none },
  --         NavicIconsKey = { bg = colors.none },
  --         NavicIconsEnum = { bg = colors.none },
  --         NavicIconsFile = { bg = colors.none },
  --         NavicIconsNull = { bg = colors.none },
  --         NavicIconsArray = { bg = colors.none },
  --         NavicIconsClass = { bg = colors.none },
  --         NavicIconsEvent = { bg = colors.none },
  --         NavicIconsField = { bg = colors.none },
  --         NavicIconsMethod = { bg = colors.none },
  --         NavicIconsModule = { bg = colors.none },
  --         NavicIconsNumber = { bg = colors.none },
  --         NavicIconsObject = { bg = colors.none },
  --         NavicIconsString = { bg = colors.none },
  --         NavicIconsStruct = { bg = colors.none },
  --         NavicIconsBoolean = { bg = colors.none },
  --         NavicIconsPackage = { bg = colors.none },
  --         NavicIconsConstant = { bg = colors.none },
  --         NavicIconsFunction = { bg = colors.none },
  --         NavicIconsOperator = { bg = colors.none },
  --         NavicIconsProperty = { bg = colors.none },
  --         NavicIconsVariable = { bg = colors.none },
  --         NavicIconsInterface = { bg = colors.none },
  --         NavicIconsNamespace = { bg = colors.none },
  --         NavicIconsEnumMember = { bg = colors.none },
  --         NavicIconsConstructor = { bg = colors.none },
  --         NavicIconsTypeParameter = { bg = colors.none },
  --         DapStoppedLine = { bg = "#1e1e2e" },
  --       }
  --     end,
  --     color_overrides = {
  --       mocha = {
  --         rosewater = "#efc9c2",
  --         flamingo = "#ebb2b2",
  --         pink = "#f2a7de",
  --         mauve = "#b889f4",
  --         red = "#ea7183",
  --         maroon = "#ea838c",
  --         peach = "#f39967",
  --         yellow = "#eaca89",
  --         green = "#96d382",
  --         teal = "#78cec1",
  --         sky = "#91d7e3",
  --         sapphire = "#68bae0",
  --         blue = "#739df2",
  --         lavender = "#a0a8f6",
  --         text = "#b5c1f1",
  --         subtext1 = "#a6b0d8",
  --         subtext0 = "#959ec2",
  --         overlay2 = "#848cad",
  --         overlay1 = "#717997",
  --         overlay0 = "#63677f",
  --         surface2 = "#505469",
  --         surface1 = "#3e4255",
  --         surface0 = "#2c2f40",
  --         base = "#1a1c2a",
  --         mantle = "#141620",
  --         crust = "#0e0f16",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "tokyonight.nvim",
  --   priority = 1000,
  --   opts = function()
  --     return {
  --       style = "moon",
  --       transparent = true,
  --       styles = {
  --         sidebars = "transparent",
  --         floats = "transparent",
  --       },
  --       on_colors = function(colors)
  --         colors.bg_statusline = colors.none -- transparent lualine/navic/
  --       end,
  --       on_highlights = function(hl, c)
  --         hl.CursorLineNr = { fg = c.orange, bold = true }
  --         hl.CursorLine = { bg = "#1e1c2a" }
  --         -- hl.LineNr = { fg = c.orange, bold = true }
  --         hl.LineNrAbove = { fg = c.fg_gutter }
  --         hl.LineNrBelow = { fg = c.fg_gutter }
  --         hl.TreesitterContext = { bg = "none" }
  --         hl.NeoTreeFileName = { fg = "white" }
  --         hl.NeoTreeGitModified = { fg = c.orange }
  --         hl.DiagnosticUnnecessary = { fg = "#918fbb" } -- unused variables etc
  --       end,
  --     }
  --   end,
  -- },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   opts = {
  --     variant = "moon",
  --     dark_variant = "moon",
  --     disable_background = true,
  --     disable_float_background = true,
  --     disable_italics = true,
  --     highlight_groups = {
  --       TreesitterContext = { bg = "none" },
  --       TreesitterContextLineNumber = { bg = "none" },
  --       Comment = { italic = true },
  --       FloatBorder = { fg = "subtle", bg = "none" },
  --       TelescopeBorder = { fg = "subtle", bg = "none" },
  --       TelescopeNormal = { fg = "none" },
  --       TelescopePromptNormal = { bg = "none" },
  --       TelescopeResultsNormal = { fg = "subtle", bg = "none" },
  --       TelescopeSelection = { fg = "text", bg = "text", blend = 10 },
  --       TelescopeSelectionCaret = { fg = "base", bg = "text" },
  --       ColorColumn = { bg = "rose" },
  --       MiniIndentscopeSymbol = { fg = "rose" },
  --       CursorLine = { bg = "#1e1c2a" },
  --       StatusLine = { fg = "love", bg = "love", blend = 10 },
  --       StatusLineNC = { fg = "subtle", bg = "surface" },
  --       GitSignsAdd = { fg = "iris", bg = "none" },
  --       TabLine = { bg = "none" },
  --       GitSignsChange = { fg = "foam", bg = "none" },
  --       GitSignsDelete = { fg = "rose", bg = "none" },
  --     },
  --   },
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   opts = {
  --     style = "deep", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  --     transparent = true, -- Show/hide background
  --     term_colors = true, -- Change terminal color as per the selected theme style
  --     cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
  --
  --     code_style = {
  --       comments = "italic",
  --       keywords = "bold",
  --       functions = "none",
  --       strings = "none",
  --       variables = "none",
  --     },
  --
  --     lualine = {
  --       transparent = true, -- lualine center bar transparency
  --     },
  --
  --     colors = {},
  --     highlights = {
  --       StatusLine = { bg = "none" },
  --       NormalFloat = { bg = "none" },
  --       WinBar = { bg = "none" },
  --       WinBarNC = { bg = "none" },
  --       DapStoppedLine = { bg = "#1e1e2e" },
  --       -- DiagnosticWarn = { bg = "#1e1e2e" },
  --       DiagnosticWarn = { bg = "none" },
  --       CursorLine = { bg = "none" },
  --       CodeBlock = { bg = "#1e1e2e" },
  --       MatchParen = { bg = "none", fg = "#f7768e" },
  --       FloatBorder = { bg = "none" },
  --     },
  --
  --     -- Plugins Config --
  --     diagnostics = {
  --       darker = true, -- darker colors for diagnostic
  --       undercurl = true, -- use undercurl instead of underline for diagnostics
  --       background = false, -- use background color for virtual text
  --     },
  --   },
  -- },
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
  --         TreesitterContext = { bg = "none" },
  --         DiagnosticVirtualTextHint = { bg = "none" },
  --         DiagnosticVirtualTextWarn = { bg = "none" },
  --         DiagnosticVirtualTextError = { bg = "none" },
  --         DiagnosticVirtualTextInformation = { bg = "none" },
  --         IblIndent = { fg = "#333333" },
  --         CodeBlock = { bg = "#1a1c2a" },
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
        borderless_telescope = false,
        terminal_colors = true,

        theme = {
          variant = "dark",
          highlights = {
            CursorColumn = { bg = "none" },
            FoldColumn = { bg = "none" },
            IblIndent = { fg = "#333333" },
            CodeBlock = { bg = "#1e1e2e" },
            CursorLine = { bg = "none" },
          },
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
          highlights.StatusLine = { bg = colors.none }
          highlights.StatusLineNC = { bg = colors.none }
        end,
      })
    end,
  },
  { "diegoulloao/neofusion.nvim", priority = 1000, config = true, opts = {} },
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
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
