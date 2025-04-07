return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      keymaps = {
        toggle = {
          normal = "<C-q>", -- Normal mode keymap for toggling Claude Code, false to disable
          terminal = "<C-q>", -- Terminal mode keymap for toggling Claude Code, false to disable
        },
      },
    })
  end,
}
