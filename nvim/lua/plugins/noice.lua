return {
  "folke/noice.nvim",
  -- opts = function(_, opts)
  --   opts.lsp.hover = {
  --     silent = true,
  --   }
  --   opts.lsp.signature = { -- disable auto popup signature
  --     auto_open = {
  --       enabled = false,
  --     },
  --   }
  -- end,
  opts = {
    lsp = {
      hover = {
        silent = true,
      },
      signature = {
        auto_open = {
          enabled = false,
          trigger = false,
        },
      },
    },
  },
}
