local util = require("lspconfig.util")

return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "emmet-language-server",
        "prisma-language-server",
        "vue-language-server",
        "css-lsp",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true, -- to fix having to restart lsp when adding/removing files
          },
        },
      },
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        vtsls = {
          keys = {
            {
              "<leader>cu",
              function()
                require("vtsls").commands.remove_unused()
              end,
              desc = "Remove unused imports",
            },
            {
              "gD",
              function()
                require("vtsls").commands.goto_source_definition(0)
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                require("vtsls").commands.file_references(0)
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              function()
                require("vtsls").commands.organize_imports(0)
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              function()
                require("vtsls").commands.add_missing_imports(0)
              end,
              desc = "Add missing imports",
            },
            {
              "<leader>cD",
              function()
                require("vtsls").commands.fix_all(0)
              end,
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                require("vtsls").commands.select_ts_version(0)
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              -- hint = {
              --   enable = true,
              -- },
            },
          },
        },
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
