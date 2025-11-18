return {
  {
    "tpope/vim-fugitive",
  },
  { "lewis6991/gitsigns.nvim", opts = {
    current_line_blame = true,
  } },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        diffview = true,
        snacks = true,
      },
      kind = "vsplit",
    },
    keys = {
      { "<leader>gn", "<cmd>lua require('neogit').open()<CR>", desc = "Neogit Status" },
    },
  },
}
