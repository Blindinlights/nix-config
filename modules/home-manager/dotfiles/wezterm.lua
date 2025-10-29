local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end
-- config.window_decorations = "RESIZE"
function apply_theme(window)
  local appearance = window:get_appearance()
  local color_scheme
  if appearance:find("Dark") then
    color_scheme = 'Catppuccin Mocha'
  else
    color_scheme = 'Catppuccin Mocha'
  end
  window:set_config_overrides({ color_scheme = color_scheme })
end

-- concfig.color_scheme = 'Catppuccin Mocha'
wezterm.on('window-config-reloaded', function(window, pane)
  apply_theme(window)
end)
config.font = wezterm.font_with_fallback { 'JetBrainsMono Nerd Font', 'Noto Color Emoji' }
config.font_size = 15.0

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.use_fancy_tab_bar = true
config.scrollback_lines = 5000
config.window_close_confirmation = 'NeverPrompt'
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
