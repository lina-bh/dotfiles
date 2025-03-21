local wezterm = require 'wezterm'

config = wezterm.config_builder()
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
config.colors = { foreground = "#ffffff", }
config.force_reverse_video_cursor = true
config.initial_cols = 98
config.initial_rows = 25
config.background = {
  {
    source = {File=wezterm.config_dir .. "/background.jpg"},
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
config.default_prog = { 'fish' }

return config
