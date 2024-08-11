local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(100, 0)
end)

config.initial_cols = 215
config.initial_rows = 62

config.font = wezterm.font_with_fallback {
  { family = 'SF Mono', weight = 'Medium' },
  'Apple Color Emoji'
}
config.font_size = 12
config.line_height = 1.16

config.color_scheme = 'Catppuccin Mocha'
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
  left = '10px',
  right = '10px',
  top = '10px',
  bottom = '10px'
}

return config
