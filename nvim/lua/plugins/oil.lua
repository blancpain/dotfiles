local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  require("oil").setup({
    float = {
      max_height = 40,
      max_width = 100,
      border = "rounded",
    },
    keymaps = {
      ["<C-h>"] = false,
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return vim.startswith(name, ".DS_Store")
      end,
    },
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
  })
  vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
end

return M
