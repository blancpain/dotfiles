return {
  "folke/which-key.nvim",
  config = function()
    local wk = require("which-key")
    wk.register({
      ["<leader>"] = {
        w = { "<Cmd>w<CR>", "Save Buffer" },
        q = { ":bd<CR>", "Close Buffer" },
      },
    })
  end,
}
