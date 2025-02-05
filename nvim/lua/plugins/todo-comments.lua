return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble" },
  event = "LazyFile",
  config = true,
  -- stylua: ignore
  opts = {
    keywords = {
      Q = {
        icon = " ",
        color = "info", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
    },
  },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next Todo Comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous Todo Comment",
    },
    -- trouble
    { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO}}<cr>", desc = "Todo (Trouble)" },
    { "<leader>xF", "<cmd>Trouble todo toggle filter = {tag = {FIX,FIXME}}<cr>", desc = "Fix/Fixme (Trouble)" },
    { "<leader>xN", "<cmd>Trouble todo toggle filter = {tag = {NOTE}}<cr>", desc = "NOTE (Trouble)" },
    { "<leader>xU", "<cmd>Trouble todo toggle filter = {tag = {Q}}<cr>", desc = "Q (Trouble)" },

    -- snacks picker
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo/Fix/Fixme/Note/Questions",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO" } })
      end,
      desc = "Todo",
    },

    {
      "<leader>sF",
      function()
        Snacks.picker.todo_comments({ keywords = { "FIX", "FIXME" } })
      end,
      desc = "Fix/Fixme",
    },
    {
      "<leader>sN",
      function()
        Snacks.picker.todo_comments({ keywords = { "NOTE" } })
      end,
      desc = "Note",
    },
    {
      "<leader>sU",
      function()
        Snacks.picker.todo_comments({ keywords = { "Q" } })
      end,
      desc = "Questions",
    },

    -- old for fzf-lua
    -- {
    --   "<leader>sF",
    --   function()
    --     require("todo-comments.fzf").todo({ keywords = { "FIX", "FIXME" } })
    --   end,
    --   desc = "Fix/Fixme",
    -- },
    -- {
    --   "<leader>sN",
    --   function()
    --     require("todo-comments.fzf").todo({ keywords = { "NOTE" } })
    --   end,
    --   desc = "Note",
    -- },
  },
}
