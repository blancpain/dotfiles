return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "obsidian",
        path = vim.fn.expand("~/repos/obsidian"),
      },
    },

    ui = {
      enable = false,
    },

    picker = {
      name = Snacks,
    },

    -- see below for full list of options 👇
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Obsidian note", mode = "n" },
    { "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes", mode = "n" },
    { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch", mode = "n" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks", mode = "n" },
    { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Follow link under cursor", mode = "n" },
  },
}
