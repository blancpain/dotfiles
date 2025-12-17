return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "lsp",
          kind = "progress",
          find = "pyright",
        },
        opts = { skip = true },
      },
    },
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
