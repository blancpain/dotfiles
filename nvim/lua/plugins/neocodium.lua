return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup({
      show_label = false,
    })
    vim.keymap.set("i", "<c-l>", neocodeium.accept)
  end,
}
