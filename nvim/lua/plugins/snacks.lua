return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    notifier = { enabled = false },
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
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          height = 5,
          cmd = "eval \"echo 'Zzz'\"",
          padding = 4,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = vim.fn.isdirectory(".git") == 1,
          cmd = 'eval "hub status --short --branch --renames"',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
  },
}
