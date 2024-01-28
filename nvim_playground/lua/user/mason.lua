local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim" -- needed for auto installing formatters etc
  },
}

function M.config()
  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "tsserver",
    "docker_compose_language_service",
    "dockerls",
    "eslint",
    "tsserver",
    "bashls",
    "jsonls",
    "yamlls",
  }

  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-tool-installer").setup {
    ensure_installed = {
      "prettier",
      "stylua",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = servers,
  }
end

return M
