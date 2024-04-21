return {
  "utilyre/barbecue.nvim",
  name = "barbecue",

  enabled = false,
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbecue").setup()
  end,
}
