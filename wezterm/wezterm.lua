local wezterm = require("wezterm")
local config = {}

-- use config builder if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_decorations = "RESIZE"
config.font_size = 20
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", weight = 500, scale = 0.80 },
	-- { family = "JetBrains Mono", weight = 500, scale = 0.75 },
})
--config.color_scheme = "Windows 10 (base16)"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.15
config.macos_window_background_blur = 70
config.window_padding = { left = 10, right = 10, top = 5, bottom = 0 }
config.line_height = 1.10
config.cell_width = 0.95
config.adjust_window_size_when_changing_font_size = false

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.underline_thickness = 3
config.underline_position = -8
config.scrollback_lines = 10000

-- NOTE: fixes c-i issue in tmux - see tmux.conf for details
config.keys = {
	{
		key = "i",
		mods = "CTRL",
		action = wezterm.action({ SendString = "\x1b[24~\x09" }),
	},
}

-- tabs
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.unzoom_on_switch_pane = true

return config
