return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
  build = "make",
  opts = {
    -- NOTE: below experimental for deepseek but it means that deepseek will be the default
    -- provider = "openai",
    -- auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    -- openai = {
    --   endpoint = "https://api.deepseek.com",
    --   model = "deepseek-chat",
    --   timeout = 30000, -- Timeout in milliseconds
    --   temperature = 0,
    --   max_tokens = 4096,
    --   -- optional
    --   api_key_name = "DEEPSEEK_API_KEY",
    -- },
    file_selector = {
      provider = "snacks",
      provider_opts = {},
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
