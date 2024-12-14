return {
  "saghen/blink.cmp",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      -- ["<Tab>"] = {
      --   function(cmp)
      --     if cmp.is_in_snippet() then
      --       return cmp.accept()
      --     else
      --       return cmp.select_and_accept()
      --     end
      --   end,
      --   "snippet_forward",
      --   "fallback",
      -- },
      -- ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
}
