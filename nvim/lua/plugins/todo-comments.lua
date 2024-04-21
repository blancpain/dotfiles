return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  config = true,
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    -- trouble
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>xF", "<cmd>TodoTrouble keywords=FIX,FIXME<cr>", desc = "Fix/Fixme (Trouble)" },
    { "<leader>xN", "<cmd>TodoTrouble keywords=NOTE<cr>", desc = "Note (Trouble)" },
    -- telescope
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    { "<leader>sF", "<cmd>TodoTelescope keywords=FIX,FIXME<cr>", desc = "Fix/Fixme (Trouble)" },
    { "<leader>sN", "<cmd>TodoTelescope keywords=NOTE<cr>", desc = "Note" },
  },
}
