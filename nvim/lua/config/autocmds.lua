-- disable new line comment on enter
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- re erratic behaviour of tab
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    if
      ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
      and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})

-- fixes weird behaviour with snippets and tab completion
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      -- luasnip.unlink_current()
      vim.cmd([[silent! lua require("luasnip").unlink_current()]])
    end
  end,
})

-- vue/ts setup
local lsp_conficts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
if not lsp_conficts then
  vim.api.nvim_create_augroup("LspAttach_conflicts", {})
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_conflicts",
  desc = "prevent tsserver and volar competing",
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
        if client_.name == "tsserver" then
          client_.stop()
        end
      end
    elseif client.name == "tsserver" then
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
