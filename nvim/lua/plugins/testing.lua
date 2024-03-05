return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    adapters = {
      ["neotest-jest"] = {
        -- below for monorepos as per https://github.com/nvim-neotest/neotest-jest
        -- jestConfigFile = function()
        --   local file = vim.fn.expand("%:p")
        --   if string.find(file, "/packages/") then
        --     return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
        --   end
        --   return vim.fn.getcwd() .. "/jest.config.ts"
        -- end,
        -- cwd = function()
        --   local file = vim.fn.expand("%:p")
        --   if string.find(file, "/packages/") then
        --     return string.match(file, "(.-/[^/]+/)src")
        --   end
        --   return vim.fn.getcwd()
        -- end,
      },
    },
    -- Example for loading neotest-go with a custom config
    -- adapters = {
    --   ["neotest-go"] = {
    --     args = { "-tags=integration" },
    --   },
    -- },
  },
}
