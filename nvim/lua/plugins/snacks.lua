return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    notifier = { enabled = false },
    image = { enabled = false },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = {
      preset = {
        header = [[
██████╗ ██╗      █████╗ ███╗   ██╗ ██████╗██████╗  █████╗ ██╗███╗   ██╗
██╔══██╗██║     ██╔══██╗████╗  ██║██╔════╝██╔══██╗██╔══██╗██║████╗  ██║
██████╔╝██║     ███████║██╔██╗ ██║██║     ██████╔╝███████║██║██╔██╗ ██║
██╔══██╗██║     ██╔══██║██║╚██╗██║██║     ██╔═══╝ ██╔══██║██║██║╚██╗██║
██████╔╝███████╗██║  ██║██║ ╚████║╚██████╗██║     ██║  ██║██║██║ ╚████║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
 ]],
      },
    },
    zen = {
      enabled = true,
      backdrop = 0.95,
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
    },
  },
  indent = {
    enabled = false,
  },
}
