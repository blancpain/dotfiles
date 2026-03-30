return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  cond = vim.fn.isdirectory(vim.fn.expand("~/repos/obsidian")) == 1,
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

        local function clean_list(list)
          local cleaned = {}
          for _, v in ipairs(list or {}) do
            if v ~= nil and v ~= "" then
              cleaned[#cleaned + 1] = v
            end
          end
          return cleaned
        end

        local out = {
          id = id,
          aliases = clean_list(note.aliases),
          tags = clean_list(note.tags),
          area = {},
          project = {},
        }
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
