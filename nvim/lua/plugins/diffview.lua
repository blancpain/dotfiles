return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  opts = {
    file_panel = {
      win_config = {
        position = "bottom",
        width = 35,
        height = 16,
      },
    },
  },
  keys = {
    { "<leader>gk", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    { "<leader>gK", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
  },
}
