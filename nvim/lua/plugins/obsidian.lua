return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "obsidian",
        path = vim.fn.expand("~/repos/obsidian"),
      },
    },

    ui = {
      enable = false,
    },

    picker = {
      name = Snacks,
    },

    note_id_func = function(title)
      return title
    end,

    frontmatter = {
      func = function(note)
        local id = tostring(note.id)
        if not id:match("^%d+%-") then
          id = tostring(os.time()) .. "-" .. id
        end
        local out = { id = id, aliases = note.aliases, tags = note.tags, area = {}, project = {} }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    },
  },
  keys = {
    {
      "<leader>on",
      function()
        local title = vim.fn.input("Note title: ")
        if title ~= "" then
          vim.cmd("Obsidian new " .. title)
        end
      end,
      desc = "New Obsidian note",
      mode = "n",
    },
    { "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes", mode = "n" },
    { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch", mode = "n" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks", mode = "n" },
    { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Follow link under cursor", mode = "n" },
  },
}
