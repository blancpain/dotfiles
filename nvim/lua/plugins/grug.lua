return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>sz",
      function()
        local grug = require("grug-far")
        grug.open({
          prefills = { paths = vim.fn.expand("%") },
        })
      end,
      desc = "Search and Replace in current buffer",
    },
  },
}
