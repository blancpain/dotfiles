return {
  -- TODO: check if vim.tbl_deep_extend is necessary
  {
    "saghen/blink.cmp",
    dependencies = { "xzbdmw/colorful-menu.nvim" },
    opts = function(_, opts)
      local colorful_menu = require("colorful-menu")

      -- Merge keymap settings
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        preset = "enter",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return require("blink.cmp").select_next()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "snippet_forward",
          "fallback",
        },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      })

      -- Merge signature settings
      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        enabled = true,
        window = {
          border = "rounded",
        },
      })

      -- Merge appearance settings
      opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
        kind_icons = {
          Snippet = "",
        },
      })

      -- Merge completion settings
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        ghost_text = {
          enabled = false,
        },
        menu = {
          min_width = 20,
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "source" } },
            components = {
              label = {
                text = colorful_menu.blink_components_text,
                highlight = colorful_menu.blink_components_highlight,
              },

              source = {
                text = function(ctx)
                  local map = {
                    ["lsp"] = "[]",
                    ["path"] = "[󰉋]",
                    ["snippets"] = "[]",
                  }

                  return map[ctx.item.source_id]
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
      })

      return opts
    end,
  },
}
