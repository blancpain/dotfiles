-- note that some configs are also set in keybindings
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    indent = { enabled = false },
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
    picker = {
      actions = {
        sidekick_send = function(...)
          return require("sidekick.cli.picker.snacks").send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<C-b>"] = {
              "sidekick_send",
              mode = { "n", "i" },
            },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
