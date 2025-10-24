-- disable new line comment on enter
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- FIX: might not be needed as vue now included in extra - double check...
-- vue/ts setup
local lsp_conficts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
if not lsp_conficts then
  vim.api.nvim_create_augroup("LspAttach_conflicts", {})
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_conflicts",
  desc = "prevent vtsls and volar competing",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local active_clients = vim.lsp.get_active_clients()
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- prevent tsserver and volar competing
    -- if client.name == "volar" or require("lspconfig").util.root_pattern("nuxt.config.ts")(vim.fn.getcwd()) then
    -- OR
    if client.name == "volar" then
      for _, client_ in pairs(active_clients) do
        -- stop tsserver if volar is already active
        if client_.name == "vtsls" then
          client_.stop()
        end
      end
    elseif client.name == "vtsls" then
      for _, client_ in pairs(active_clients) do
        -- prevent tsserver from starting if volar is already active
        if client_.name == "volar" then
          client.stop()
        end
      end
    end
  end,
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
  callback = function(args)
    vim.diagnostic.disable(args.buf)
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
