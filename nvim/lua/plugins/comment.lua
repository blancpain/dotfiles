return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = {
        ---Line-comment toggle keymap
        line = "<Leader>/",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      -- visual mode mappings
      opleader = {
        ---Line-comment keymap
        line = "<Leader>/",
        ---Block-comment keymap
        block = "gb",
      },
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    },
  },
}
