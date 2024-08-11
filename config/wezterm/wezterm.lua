local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(115, 0)
end)

config.initial_cols = 200
config.initial_rows = 60

config.font = wezterm.font_with_fallback {
  { family = 'SF Mono', weight = 'Medium' },
  'Apple Color Emoji'
}
config.font_size = 13
config.line_height = 1.16

config.color_scheme = 'Catppuccin Mocha'
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
  left = '7px',
  right = '7px',
  top = '7px',
  bottom = '7px'
}

return config
