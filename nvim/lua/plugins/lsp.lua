local util = require("lspconfig.util")

return {
  -- tools
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "emmet-language-server",
  --       "prisma-language-server",
  --       "vue-language-server",
  --       "css-lsp",
  --     })
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    init = function()
      --[[Modify LSP keymaps]]
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- NOTE: make sure you include "mode" as without it disabling doesn't seem to work
      -- see: https://github.com/dpetka2001/dotfiles/blob/main/dot_config/nvim/lua/plugins/lsp.lua
      keys[#keys + 1] = { "<C-k>", false, mode = { "i" } }
      keys[#keys + 1] = {
        "<C-g>",
        function()
          return vim.lsp.buf.signature_help()
        end,
        mode = { "i" },
        desc = "Signature Help",
        has = "signatureHelp",
      }
    end,
    opts = {
      inlay_hints = {
        enabled = true,
        exclude = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true, -- NOTE: to fix having to restart lsp when adding/removing files
          },
        },
      },
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        -- TODO: see if below needed as inc in extras now
        volar = {
          filetypes = {
            "typescript",
            "vue",
          },
          root_dir = util.root_pattern("src/App.vue"),
          languageFeatures = {
            implementation = true,
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            workspaceSymbol = true,
          },
        },
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "non-relative",
              },
            },
          },
        },
        -- nil_ls = {
        --   settings = {
        --     ["nil"] = {
        --       formatting = {
        --         command = { "nixfmt" },
        --       },
        --     },
        --   },
        -- },
        emmet_language_server = {
          filetypes = {
            "css",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "pug",
            "typescriptreact",
          },
        },
      },
    },
  },
}
