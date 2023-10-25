local wezterm = require("wezterm")
local config = {}

-- use config builder if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.window_decorations = "RESIZE"
config.font_size = 17.5
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", weight = 400, scale = 0.85 },
})
config.use_fancy_tab_bar = false
-- config.color_scheme = "Rosé Pine (base16)"
-- config.color_scheme = "3024 Night"
config.color_scheme = "Bright (base16)"
-- config.color_scheme = "Builtin Dark"
-- config.color_scheme = "tokyonight"
-- config.color_scheme = "deep"
-- config.color_scheme = "carbonfox"
config.window_background_opacity = 0.7
-- config.window_padding = { left = 10, right = 10, top = 5, bottom = 0 }
config.macos_window_background_blur = 10
config.line_height = 1.15
config.adjust_window_size_when_changing_font_size = false

-- check if below make a difference?
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.underline_thickness = 3
config.underline_position = -6

return config
