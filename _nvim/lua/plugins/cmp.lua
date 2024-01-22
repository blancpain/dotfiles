return {

  -- disable cmp when inside strings or comments - the first is not snippets and the second is for buffers
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      for _, source in ipairs(opts.sources) do
        if source.name == "luasnip" then
          source.option = { use_show_condition = true }
          source.entry_filter = function()
            local context = require("cmp.config.context")
            local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
            local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")

            --   Returning `true` will keep the entry, while returning `false` will remove it.
            return not string_ctx and not comment_ctx
          end
        end
        if source.name == "buffer" then
          source.option = { use_show_condition = true }
          source.entry_filter = function()
            local context = require("cmp.config.context")
            local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
            local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")

            --   Returning `true` will keep the entry, while returning `false` will remove it.
            return not string_ctx and not comment_ctx
          end
        end
        if source.name == "nvim_lsp" then
          source.option = { use_show_condition = true }
          source.entry_filter = function()
            local context = require("cmp.config.context")
            local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
            local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")

            --   Returning `true` will keep the entry, while returning `false` will remove it.
            return not string_ctx and not comment_ctx
          end
        end
      end
    end,
  },
}
