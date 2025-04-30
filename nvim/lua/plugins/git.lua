return {
  {
    "NeogitOrg/neogit",
    branch = "nightly",
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
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      -- current_line_blame = true, --TODO: bring back once fixed
    },
  },
}
