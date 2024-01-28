return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot-cmp",
    },

    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          jump_next = "<c-j>",
          jump_prev = "<c-k>",
          accept = "<c-l>",
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false, -- disable built-in keymapping
          keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
          },
        },
      })
    end,
  },
}
