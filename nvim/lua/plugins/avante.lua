return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
  build = "make",
  opts = {
    -- NOTE: below experimental for deepseek but it means that deepseek will be the default
    -- provider = "deepseek",
    -- vendors = {
    --   deepseek = {
    --     __inherited_from = "openai",
    --     api_key_name = "DEEPSEEK_API_KEY",
    --     endpoint = "https://api.deepseek.com",
    --     model = "deepseek-coder",
    --   },
    -- },
    mode = "legacy", -- legacy or agentic
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-7-sonnet-20250219",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 8000,
      disable_tools = true, -- Disable tools for now (it's enabled by default) as it's causing rate-limit problems with Claude, see more here: https://github.com/yetone/avante.nvim/issues/1384
    },
    selector = {
      provider = "snacks",
    },
    windows = {
      width = 50,
      ask = {
        start_insert = false,
      },
    },
  },
  keys = {
    { "<leader>al", "<cmd>AvanteClear<cr>", desc = "avante: clear" },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    {
      "saghen/blink.compat",
      lazy = true,
      opts = {},
      config = function()
        -- monkeypatch cmp.ConfirmBehavior for Avante
        require("cmp").ConfirmBehavior = {
          Insert = "insert",
          Replace = "replace",
        }
      end,
    },
    {
      "saghen/blink.cmp",
      lazy = true,
      opts = {
        sources = {
          compat = { "avante_commands", "avante_mentions", "avante_files" },
        },
      },
    },
  },
}
