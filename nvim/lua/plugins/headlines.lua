return {
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    markdown = {
      headline_highlights = false, --disable since using tsnode-marker for codeblocks
      codeblock_highlight = false,
    },
  },
}
