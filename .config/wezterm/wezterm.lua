local wezterm = require("wezterm")
local action = wezterm.action

config = wezterm.config_builder()
config:set_strict_mode(false)
config.font = wezterm.font("JetBrainsMonoNL Nerd Font")
config.font_size = 10.0
-- config.cell_width = 0.85
config.window_padding = {
	top = 1,
	left = 1,
	right = 0,
	bottom = 0,
}
config.use_resize_increments = true
config.colors = { foreground = "#ffffff" }
config.force_reverse_video_cursor = true
config.initial_cols = 98
config.initial_rows = 25
config.background = {
	{
		source = { File = wezterm.config_dir .. "/background.jpg" },
		opacity = 0.88,
		hsb = {
			saturation = 0.5,
			brightness = 0.006,
		},
	},
}
config.window_close_confirmation = "NeverPrompt"
-- config.swallow_mouse_click_on_pane_focus = true
config.window_frame = {
	font_size = 10,
}
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.default_prog = { "fish" }

-- config.key_map_preference = "Mapped"
config.leader = {
	mods = "CTRL",
	key = "b",
}
-- config.leader.timeout_milliseconds = 2000
config.keys = {
	{
		mods = "LEADER|CTRL",
		key = "b",
		action = action.SendKey({ mods = "CTRL", key = "b" }),
	},
	{
		mods = "LEADER|SHIFT",
		key = '"',
		action = action.SplitPane({ direction = "Down" }),
	},
	{
		mods = "LEADER|SHIFT",
		key = "%",
		action = action.SplitPane({ direction = "Right" }),
	},
	{
		mods = "LEADER",
		key = "c",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
}
config.window_decorations = "TITLE|RESIZE"

return config
