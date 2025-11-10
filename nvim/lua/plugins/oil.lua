local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  require("oil").setup({
    float = {
      max_height = 40,
      max_width = 150,
      -- padding = 20,
      border = "rounded",
    },
    -- columns = {
    --   "icon",
    --   "size",
    -- },
    keymaps = {
      ["<C-h>"] = false,
    },
    -- win_options = {
    --   winbar = "%{v:lua.require('oil').get_current_dir()}", -- show current directory in winbar
    -- },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return vim.startswith(name, ".DS_Store")
      end,
    },
    lsp_file_methods = {
      -- Enable or disable LSP file operations
      enabled = true,
      -- Time to wait for LSP file operations to complete before skipping
      timeout_ms = 1000,
      -- Set to true to autosave buffers that are updated with LSP willRenameFiles
      -- Set to "unmodified" to only save unmodified buffers
      autosave_changes = true,
    },
  })
  vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
  -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M
