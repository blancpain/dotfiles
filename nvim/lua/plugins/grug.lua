return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>sr",
      function()
        local is_visual = vim.fn.mode():lower():find("v")
        if is_visual then -- needed to make visual selection work
          vim.cmd([[normal! v]])
        end
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        local filesFilter = ext and ext ~= "" and "*." .. ext or nil; -- check if we actually needs this - it prefills the file type
        (is_visual and grug.with_visual_selection or grug.grug_far)({
          prefills = { filesFilter = filesFilter },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
    {
      "<leader>sz",
      function()
        local grug = require("grug-far")
        grug.grug_far({
          prefills = { flags = vim.fn.expand("%") },
        })
      end,
      desc = "Search and Replace in current buffer",
    },
  },
}