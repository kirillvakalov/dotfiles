paneru.setup({
  options = {
    focus_follows_mouse = true,
    mouse_follows_focus = true,
    animation_speed = 9999.0,
  },
  bindings = {
    ['window focus west'] = 'alt - h',
    ['window swap west'] = 'alt + shift - h',
    ['window focus east'] = 'alt - l',
    ['window swap east'] = 'alt + shift - l',
    ['window resize'] = 'alt - r',
    ['window manage'] = 'alt - f', -- Toggle floating mode
    ['window fullwidth'] = 'alt - z',
    ['window virtualnum 1'] = 'alt - 1',
    ['window virtualnum 2'] = 'alt - 2',
    ['window virtualnum 3'] = 'alt - 3',
    ['window virtualnum 4'] = 'alt - 4',
  },
  swipe = {
    gesture = { fingers_count = 0, vertical = false },
  },
  decorations = { workspace_popup_status = false },
  -- Do not manage any windows by default
  windows = {
    all = { title = '.*', floating = true },
  },
})

-- Add bundle IDs here for apps whose windows should tile
local tiled_apps = {
  'com.mitchellh.ghostty',
  'com.google.Chrome',
  'com.tinyspeck.slackmacgap',
}

paneru.on('window_spawned', function(event, ws)
  for _, bundle_id in ipairs(tiled_apps) do
    if bundle_id == event.bundle_id then return ws:sink(event.window_id) end
  end
end)
