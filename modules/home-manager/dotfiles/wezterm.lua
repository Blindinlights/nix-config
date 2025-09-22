local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end
-- config.window_decorations = "RESIZE"
config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font('FiraCode Nerd Font')
config.font_size = 15.0

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.use_fancy_tab_bar = true
config.scrollback_lines = 5000
config.window_close_confirmation = 'Never'
config.hyperlink_rules = wezterm.default_hyperlink_rules()

return config
