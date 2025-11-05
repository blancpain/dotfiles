-- NOTE: use below if we want to use telescope as a harpoon menu

-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--   local file_paths = {}
--   for _, item in ipairs(harpoon_files.items) do
--     table.insert(file_paths, item.value)
--   end
--
--   require("telescope.pickers")
--     .new({}, {
--       prompt_title = "Harpoon",
--       finder = require("telescope.finders").new_table({
--         results = file_paths,
--       }),
--       previewer = conf.file_previewer({}),
--       sorter = conf.generic_sorter({}),
--     })
--     :find()
-- end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  -- NOTE: optionally add plenary and telescope (if using telescope for menu) as dependencies...
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },
  keys = {
    {
      "<s-m>",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Mark file with harpoon",
    },
    {
      "<s-TAB>",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon quick menu",
    },
    -- {
    --   "<leader>h",
    --   function()
    --     local harpoon = require("harpoon")
    --     toggle_telescope(harpoon:list())
    --   end,
    --   desc = "Harpoon telescope",
    -- },
    {
      "<leader>j",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Go to next harpoon mark",
    },
    {
      "<leader>k",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Go to previous harpoon mark",
    },
    {
      "<leader>1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon to file 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon to file 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon to file 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon to file 4",
    },
    {
      "<leader>5",
      function()
        require("harpoon"):list():select(5)
      end,
      desc = "Harpoon to file 5",
    },
  },
}
