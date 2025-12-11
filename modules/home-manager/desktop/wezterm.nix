{ pkgs, ... }:
{
  home.packages = [
    pkgs.wezterm
  ];
  home.file.".config/wezterm/wezterm.lua" = {
    source = ../dotfiles/wezterm.lua;
  };
}
