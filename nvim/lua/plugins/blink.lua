return {
  { "saghen/blink.compat" },
  {
    "saghen/blink.cmp",

    opts_extend = { "sources.completion.enabled_providers" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- sources = {
      --   completion = {
      --     enabled_providers = {
      --       "lsp",
      --       "path",
      --       "snippets",
      --       "buffer",
      --       "obsidian",
      --       "obsidian_new",
      --       "obsidian_tags",
      --     },
      --   },
      -- },
      -- providers = {
      --   obsidian = {
      --     name = "obsidian",
      --     module = "blink.compat.source",
      --   },
      --   obsidian_new = {
      --     name = "obsidian_new",
      --     module = "blink.compat.source",
      --   },
      --   obsidian_tags = {
      --     name = "obsidian_tags",
      --     module = "blink.compat.source",
      --   },
      -- },
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
  },
}
