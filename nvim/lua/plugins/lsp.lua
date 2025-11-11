local util = require("lspconfig.util")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = true,
        exclude = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true, -- NOTE: to fix having to restart lsp when adding/removing files
              },
            },
          },
          keys = {
            -- Disable <C-k> in insert mode
            { "<C-k>", false, mode = "i" },
            -- Add custom signature help mapping
            {
              "<C-g>",
              function()
                return vim.lsp.buf.signature_help()
              end,
              mode = "i",
              desc = "Signature Help",
              has = "signatureHelp",
            },
          },
        },
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
