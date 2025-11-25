return {
  {

    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = {
        "markdown",
        "norg",
        "rmd",
        "org",
      },
      bullet = {
        -- padding
        left_pad = 0,
        right_pad = 1,
      },
    },
    ft = { "markdown", "norg", "rmd", "org" },
  },

  {
    "Jonathan-Al-Saadi/taskman.nvim",
    opts = {
      -- Directory to search for markdown task files
      task_dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian",
    },
    keys = {
      {
        "<leader>Nd",
        "<cmd>TaskList done<cr>",
        desc = "Completed Tasks",
      },
      {
        "<leader>Nn",
        "<cmd>TaskList todo<cr>",
        desc = "Pending Tasks",
      },
    },
  },
}
