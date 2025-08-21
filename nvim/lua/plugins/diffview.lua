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
    { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
    { "<leader>gO", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
  },
}
