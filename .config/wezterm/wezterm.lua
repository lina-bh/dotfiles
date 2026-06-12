local wezterm = require("wezterm")
local action = wezterm.action

config = wezterm.config_builder()
config:set_strict_mode(false)
config.font = wezterm.font {
  family = "IosevkaTerm Nerd Font",
  harfbuzz_features = { 'calt=0' },
}
config.font_size = 10.5
-- config.cell_width = 0.85
config.window_padding = {
  top = 1,
  left = 1,
  right = 0,
  bottom = 1,
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
      saturation = 0.8,
      brightness = 0.006,
    },
  },
}
config.window_close_confirmation = "NeverPrompt"
config.swallow_mouse_click_on_pane_focus = true
config.window_frame = {
  font_size = 10,
}
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
config.default_prog = { "zsh" }

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
    action = action.SendKey { mods = "CTRL", key = "b" },
  },
  {
    mods = "LEADER|SHIFT",
    key = '"',
    action = action.SplitPane { direction = "Down" },
  },
  {
    mods = "LEADER|SHIFT",
    key = "%",
    action = action.SplitPane { direction = "Right" },
  },
  {
    mods = "LEADER",
    key = "c",
    action = action.SpawnTab("CurrentPaneDomain"),
  },
}
config.window_decorations = "TITLE|RESIZE"
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "NONE",
    action = action.ScrollByLine(-2),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = "NONE",
    action = action.ScrollByLine(2),
  },
}

function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local active_pane = tab.active_pane
  return string.format(
    " %d : %s ",
    tab.tab_id,
    active_pane.title or basename(active_pane.foreground_process_name) -- active_pane.current_working_dir
  )
end)

return config

-- Local Variables:
-- lua-indent-level: 2
-- End:
