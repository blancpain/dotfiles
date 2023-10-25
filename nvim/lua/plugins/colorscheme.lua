return {
  {
    "rose-pine/neovim",
    lazy = false,
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
  {
    "nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },
}
