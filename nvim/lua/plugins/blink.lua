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
          "snippet_forward",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
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
          border = "rounded",
          -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 10 }, { "source" } },
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  -- Do something else
                  return highlights
                end,
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
