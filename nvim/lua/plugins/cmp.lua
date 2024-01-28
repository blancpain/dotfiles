return {
  --Use <tab> for completion and snippets (supertab)
  --first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-emoji",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-buffer",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-path",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-cmdline",
        event = "InsertEnter",
      },
      {
        "saadparwaiz1/cmp_luasnip",
        event = "InsertEnter",
      },
      {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },
      {
        "hrsh7th/cmp-nvim-lua",
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      -- below screws up neotab
      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end

      local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })

      -- fix regarding erratic tab behaviour (also have something on this in autocmd)
      local unlink_group = vim.api.nvim_create_augroup("UnlinkSnippet", {})
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = unlink_group,
        -- when going from select mode to normal and when leaving insert mode
        pattern = { "s:n", "i:*" },
        callback = function(event)
          if luasnip.session and luasnip.session.current_nodes[event.buf] and not luasnip.session.jump_active then
            luasnip.unlink_current()
          end
        end,
      })
      -- end of erratic tab behaviour

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            -- we don't need copilot as using different keymaps for that
            -- elseif require("copilot.suggestion").is_visible() then
            --   require("copilot.suggestion").accept()
            -- elseif has_words_before() then
            --   cmp.complete()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- change some defauly keymaps
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      })
    end,
  },

  -- below disables cmp when inside strings or comments - the first is for snippets and the second is for buffers
  --   {
  --     "hrsh7th/nvim-cmp",
  --     ---@param opts cmp.ConfigSchema
  --     opts = function(_, opts)
  --       for _, source in ipairs(opts.sources) do
  --         if source.name == "luasnip" then
  --           source.option = { use_show_condition = true }
  --           source.entry_filter = function()
  --             local context = require("cmp.config.context")
  --             local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
  --             local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
  --
  --             --   Returning `true` will keep the entry, while returning `false` will remove it.
  --             return not string_ctx and not comment_ctx
  --           end
  --         end
  --         if source.name == "buffer" then
  --           source.option = { use_show_condition = true }
  --           source.entry_filter = function()
  --             local context = require("cmp.config.context")
  --             local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
  --             local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
  --
  --             --   Returning `true` will keep the entry, while returning `false` will remove it.
  --             return not string_ctx and not comment_ctx
  --           end
  --         end
  --         if source.name == "nvim_lsp" then
  --           source.option = { use_show_condition = true }
  --           source.entry_filter = function()
  --             local context = require("cmp.config.context")
  --             local string_ctx = context.in_treesitter_capture("string") or context.in_syntax_group("String")
  --             local comment_ctx = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
  --
  --             --   Returning `true` will keep the entry, while returning `false` will remove it.
  --             return not string_ctx and not comment_ctx
  --           end
  --         end
  --       end
  --     end,
  --   },
}
