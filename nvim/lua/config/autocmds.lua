-- disable new line comment on enter
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- q to close some stuff
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "fugitive",
    "",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

-- Disable diagnostics for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.diagnostic.enable(false, { bufnr = event.buf })
  end,
  desc = "Disable diagnostics for markdown files",
})

-- Copilot inline completion
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "copilot" then
      -- Enable inline completion
      vim.lsp.inline_completion.enable(true)

      -- Accept inline completion with C-l
      vim.keymap.set("i", "<C-l>", function()
        local completion = vim.lsp.inline_completion.get()
        if completion then
          vim.lsp.inline_completion.select()
        else
          return "<C-l>"
        end
      end, { buffer = args.buf, expr = true, desc = "Accept Copilot Suggestion" })
    end
  end,
})
