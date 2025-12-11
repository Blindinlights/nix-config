local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.color_scheme = 'Hemisu Dark (Gogh)'
config.font = wezterm.font_with_fallback { 'JetBrainsMono Nerd Font', 'Noto Color Emoji' }
config.font_size = 15.0

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.75
-- config.use_fancy_tab_bar = true
config.scrollback_lines = 5000
config.window_close_confirmation = 'NeverPrompt'
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
