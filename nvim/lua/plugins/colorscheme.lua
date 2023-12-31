-- nightlfy settings
local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nightfly",
  callback = function()
    vim.api.nvim_set_hl(0, "WinBar", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
  group = custom_highlight,
})
vim.g.nightflyTransparent = true
-- end of nightfly settings
return {
  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
  },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  {
    "ofirgall/ofirkai.nvim",
  },
  { "cpea2506/one_monokai.nvim" },
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
      color_overrides = {
        mocha = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          lavender = "#a0a8f6",
          text = "#b5c1f1",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",
          overlay2 = "#848cad",
          overlay1 = "#717997",
          overlay0 = "#63677f",
          surface2 = "#505469",
          surface1 = "#3e4255",
          surface0 = "#2c2f40",
          base = "#1a1c2a",
          mantle = "#141620",
          crust = "#0e0f16",
        },
      },
    },
  },
  {
    "tokyonight.nvim",
    priority = 1000,
    opts = function()
      return {
        style = "moon",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        -- on_colors = function(c)
        -- local hsluv = require("tokyonight.hsluv")
        -- local function randomColor(color)
        --   if color ~= "NONE" then
        --     local hsl = hsluv.hex_to_hsluv(color)
        --     hsl[1] = math.random(0, 360)
        --     return hsluv.hsluv_to_hex(hsl)
        --   end
        --   return color
        -- end
        -- local function set(colors)
        --   if type(colors) == "table" then
        --     for k, v in pairs(colors) do
        --       if type(v) == "string" then
        --         colors[k] = randomColor(v)
        --       elseif type(v) == "table" then
        --         set(v)
        --       end
        --     end
        --   end
        -- end
        -- set(c)
        -- end,
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.CursorLine = { bg = "#1e1c2a" }
          -- hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
          hl.TreesitterContext = { bg = "none" }
          hl.NeoTreeFileName = { fg = "white" }
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
      variant = "auto",
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,
      highlight_groups = {
        Comment = { italic = true },
        FloatBorder = { fg = "subtle", bg = "none" },
        TelescopeBorder = { fg = "subtle", bg = "none" },
        TelescopeNormal = { fg = "none" },
        TelescopePromptNormal = { bg = "none" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "text", blend = 10 },
        TelescopeSelectionCaret = { fg = "base", bg = "text" },
        ColorColumn = { bg = "rose" },
        MiniIndentscopeSymbol = { fg = "rose" },
        CursorLine = { bg = "#1e1c2a" },
        StatusLine = { fg = "love", bg = "love", blend = 10 },
        StatusLineNC = { fg = "subtle", bg = "surface" },
        GitSignsAdd = { fg = "iris", bg = "none" },
        GitSignsChange = { fg = "foam", bg = "none" },
        GitSignsDelete = { fg = "rose", bg = "none" },
      },
    },
  },
  {
    "projekt0n/github-nvim-theme",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({

        options = {
          transparent = false,
          darken = { -- Darken floating windows and sidebar-like windows
            floats = true,
            sidebars = {
              enabled = true,
              list = {}, -- Apply dark background to specific windows
            },
          },
        },
      })
    end,
  },
  { "Yazeed1s/oh-lucy.nvim" },
  { "embark-theme/vim" },
  { "NLKNguyen/papercolor-theme" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
