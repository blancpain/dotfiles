return {
  "nvim-pack/nvim-spectre",
  -- stylua: ignore
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    {"<leader>sz", function() require("spectre").toggle({path=vim.fn.expand('%:t:p')}) end, desc = "Replace in Current File (Spectre)" },
  },
}
