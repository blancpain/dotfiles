local wezterm = require("wezterm")
local config = {}

-- use config builder if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_decorations = "RESIZE"
config.font_size = 22
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", weight = 500, scale = 0.80 },
	-- { family = "0xProto", weight = 500, scale = 0.80 },
	-- { family = "Victor Mono", weight = "Bold", scale = 0.80 },
	-- { family = "JetBrains Mono", weight = 500, scale = 0.75 },
	-- { family = "MesloLGM Nerd Font", weight = 600, scale = 0.80 },
})
-- config.color_scheme = "Windows 10 (base16)"
-- config.color_scheme = "Eldritch"
-- config.color_scheme = "One Half Black (Gogh)"
-- config.color_scheme = "Rosé Pine Moon (base16)"
config.color_scheme = "Rosé Pine (base16)"
-- config.color_scheme = "BlulocoDark"
-- config.color_scheme = "Catppuccin Latte"
-- config.color_scheme = "Everforest Light (Gogh)"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "Dawn (terminal.sexy)"

-- config.colors = {
-- 	background = "#16181a", -- for cyberdream nvim theme
-- }

-- config.color_scheme = "Chalkboard (Gogh)"
-- config.color_scheme = "Bamboo Multiplex"
-- config.color_scheme = "Solarized Dark Higher Contrast"
-- config.window_background_opacity = 0.75
config.macos_window_background_blur = 20
config.window_padding = { left = 5, right = 5, top = 10, bottom = 0 }
config.line_height = 1.05
config.cell_width = 0.98
config.adjust_window_size_when_changing_font_size = false

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.underline_thickness = 3
config.underline_position = -8
config.scrollback_lines = 10000

config.term = "wezterm"

-- NOTE: workaround to get c-i to work as expected, have mapped c-pageUp in nvim to c-i
config.keys = {
	{
		key = "i",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "PageUp", mods = "CTRL" }),
	},
}

-- tabs
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.unzoom_on_switch_pane = true

-- zenmode; ref: https://github.com/folke/zen-mode.nvim
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
