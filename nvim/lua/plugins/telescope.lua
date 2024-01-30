return {
  "nvim-telescope/telescope.nvim",
  opts = {
    --   defaults = {
    --     layout_strategy = "horizontal",
    --     layout_config = { prompt_position = "top" },
    --     sorting_strategy = "ascending",
    --     winblend = 0,
    --   },
    -- add some mappings
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
      },
    },
  },
  keys = {
    -- disable the keymap to grep files
    { "<leader>/", false },
  },
}
