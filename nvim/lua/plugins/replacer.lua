return {
  "gabrielpoca/replacer.nvim",
  opts = { rename_files = false },
  keys = {
    {
      "<leader>H",
      function()
        require("replacer").run()
      end,
      desc = "run replacer.nvim",
    },
  },
}
