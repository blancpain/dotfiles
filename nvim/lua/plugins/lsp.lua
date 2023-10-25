return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "emmet-language-server",
        "prisma-language-server",
      })
    end,
  },
}
