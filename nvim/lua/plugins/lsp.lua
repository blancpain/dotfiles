-- local util = require("lspconfig.util")
return {
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
    opts = function(_, opts)
      -- Get the default keymaps
      -- local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Modify keymaps here as per docs
      -- keys[#keys + 1] = { "<c-k>", false }
      -- keys[#keys + 1] = {
      --   "<c-m>",
      --   function()
      --     return vim.lsp.buf.signature_help()
      --   end,
      --   mode = "i",
      --   desc = "Signature Help",
      --   has = "signatureHelp",
      -- }

      -- Extend the default options
      -- opts.keys = keys
      opts.inlay_hints = vim.tbl_deep_extend("force", opts.inlay_hints or {}, {
        enabled = true,
        exclude = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      })
      opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true, -- NOTE: to fix having to restart lsp when adding/removing files
          },
        },
      })
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false,
      })

      -- Extend/override the servers table
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        -- TODO: see if below needed as inc in extras now
        -- volar = {
        --   filetypes = {
        --     "typescript",
        --     "vue",
        --   },
        --   root_dir = util.root_pattern("src/App.vue"),
        --   languageFeatures = {
        --     implementation = true,
        --     references = true,
        --     definition = true,
        --     typeDefinition = true,
        --     callHierarchy = true,
        --     hover = true,
        --     rename = true,
        --     renameFileRefactoring = true,
        --     signatureHelp = true,
        --     codeAction = true,
        --     workspaceSymbol = true,
        --   },
        -- },
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
      })
      return opts
    end,
  },
}
