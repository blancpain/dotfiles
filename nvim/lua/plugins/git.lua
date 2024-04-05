return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  cmd = "Neogit",
  opts = {
    signs = {
      hunk = { "", "" },
      item = { "", "" },
      section = { "", "" },
    },
    integrations = {
      diffview = true,
    },
    kind = "vsplit",
  },
  keys = {
    { "<leader>gm", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Neogit commit" },
    { "<leader>gS", "<cmd>lua require('neogit').open()<CR>", desc = "Neogit Status" },
  },
}
