local wezterm = require 'wezterm'
local config = wezterm.config_builder and wezterm.config_builder() or {}
local nerdfonts = wezterm.nerdfonts
local act = wezterm.action

local TAB_BAR_BG = '#0b1118'
local TAB_ACTIVE_BG = '#1b2a38'
local TAB_ACTIVE_FG = '#d7e3f0'
local TAB_INACTIVE_BG = '#101720'
local TAB_INACTIVE_FG = '#728196'
local TAB_HOVER_BG = '#16212d'
local TAB_HOVER_FG = '#b8c7d9'

local SOLID_LEFT_ARROW = nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = nerdfonts.pl_left_hard_divider

wezterm.on('format-tab-title', function(tab, tabs, panes, _, hover, max_width)
  local background = TAB_INACTIVE_BG
  local foreground = TAB_INACTIVE_FG

  if tab.is_active then
    background = TAB_ACTIVE_BG
    foreground = TAB_ACTIVE_FG
  elseif hover then
    background = TAB_HOVER_BG
    foreground = TAB_HOVER_FG
  end

  local edge_foreground = background
  local title = wezterm.truncate_right(string.format(' tab%d ', tab.tab_index + 1), max_width - 2)

  return {
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

config.check_for_updates = false
config.color_scheme = 'Hemisu Dark (Gogh)'
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'Source Han Mono SC',
  'Noto Color Emoji',
}
config.font_size = 15.0
config.window_padding = {
  left = 3,
  right = 1,
  top = 0,
  bottom = 0,
}

config.keys = {
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentTab { confirm = false },
  },
}
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'zellij',
  'tmux',
  'nu',
  'cmd.exe',
  'pwsh.exe',
  'powershell.exe',
}
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 8
config.window_background_opacity = 0.75
config.scrollback_lines = 5000
config.window_close_confirmation = 'NeverPrompt'
config.colors = {
  tab_bar = {
    background = TAB_BAR_BG,
    active_tab = {
      bg_color = TAB_ACTIVE_BG,
      fg_color = TAB_ACTIVE_FG,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = TAB_INACTIVE_BG,
      fg_color = TAB_INACTIVE_FG,
    },
    inactive_tab_hover = {
      bg_color = TAB_HOVER_BG,
      fg_color = TAB_HOVER_FG,
    },
    new_tab = {
      bg_color = TAB_BAR_BG,
      fg_color = TAB_INACTIVE_FG,
    },
    new_tab_hover = {
      bg_color = TAB_BAR_BG,
      fg_color = TAB_ACTIVE_FG,
    },
  },
}
config.tab_bar_style = {
  new_tab = wezterm.format {
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = TAB_INACTIVE_FG } },
    { Text = ' + ' },
  },
  new_tab_hover = wezterm.format {
    { Background = { Color = TAB_BAR_BG } },
    { Foreground = { Color = TAB_ACTIVE_FG } },
    { Text = ' + ' },
  },
}

return config
