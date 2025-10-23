return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- local colors = require("cyberdream.colors").default
    -- local cyberdream = require("lualine.themes.cyberdream")
    return {
      options = {
        component_separators = { left = " ", right = " " },
        section_separators = { left = " ", right = " " },
        -- theme = cyberdream,
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },

      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" } },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = "󰝶 ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            symbols = { modified = "  ", readonly = "", unnamed = "" },
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            -- color = function() return LazyVim.ui.fg("Statement") end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            -- color = function() return LazyVim.ui.fg("Constant") end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            -- color = function() return LazyVim.ui.fg("Debug") end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            -- color = function() return LazyVim.ui.fg("Special") end,
          },
        },
        lualine_y = {
          {
            "progress",
          },
          {
            "location",
            -- color = { fg = colors.cyan, bg = colors.none },
          },
        },
        lualine_z = {
          function()
            return "  " .. os.date("%X") .. " 🚀 "
          end,
        },
      },

      extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
    }
  end,
}
