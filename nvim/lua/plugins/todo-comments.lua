return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
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
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>xF", "<cmd>TodoTrouble keywords=FIX,FIXME<cr>", desc = "Fix/Fixme (Trouble)" },
    { "<leader>xN", "<cmd>TodoTrouble keywords=NOTE<cr>", desc = "Note (Trouble)" },
    { "<leader>xU", "<cmd>TodoTrouble keywords=Q<cr>", desc = "Questions (Trouble)" },
    -- telescope
    -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    -- { "<leader>sF", "<cmd>TodoTelescope keywords=FIX,FIXME<cr>", desc = "Fix/Fixme (Trouble)" },
    -- { "<leader>sN", "<cmd>TodoTelescope keywords=NOTE<cr>", desc = "Note" },
    -- { "<leader>sU", "<cmd>TodoTelescope keywords=Q<cr>", desc = "Questions" },
    -- fzf
    {
      "<leader>st",
      function()
        require("todo-comments.fzf").todo()
      end,
      desc = "Todo",
    },
    {
      "<leader>sT",
      function()
        require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
      end,
      desc = "Todo/Fix/Fixme",
    },
    {
      "<leader>sF",
      function()
        require("todo-comments.fzf").todo({ keywords = { "FIX", "FIXME" } })
      end,
      desc = "Fix/Fixme",
    },
    {
      "<leader>sN",
      function()
        require("todo-comments.fzf").todo({ keywords = { "NOTE" } })
      end,
      desc = "Note",
    },
    {
      "<leader>sU",
      function()
        require("todo-comments.fzf").todo({ keywords = { "Q" } })
      end,
      desc = "Questions",
    },
  },
}
