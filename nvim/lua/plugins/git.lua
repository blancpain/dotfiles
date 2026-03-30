return {
  {
    "tpope/vim-fugitive",
  },
  {
    "tpope/vim-rhubarb",
  },
  { "lewis6991/gitsigns.nvim", opts = {
    current_line_blame = true,
  } },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<leader>gk", "<cmd>CodeDiff<cr>", desc = "Git Diff" },
    },
  },
}
