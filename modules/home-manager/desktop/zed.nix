{ pkgs, ... }:
{
  home.packages = [
    pkgs.zed-editor
  ];
  home.file.".config/zed/settings.json" = {
    source = ../dotfiles/zed.json;
  };
}
