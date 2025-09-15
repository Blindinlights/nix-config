# modules/home-manager/common.nix
{ config, lib, pkgs, ... }:

{
  # 将你原来的 systemPackages 移动到这里 [cite: 19]
  home.packages = with pkgs; [
    vim
    wget
    helix
    git
    flclash
    yazi
    lsd
    fd
    ripgrep
    bat
    dust
    wezterm
    alacritty
    kdePackages.dolphin
    cosmic-term
    swaylock
    mako
    anyrun
    zellij
    xwayland-satellite
    qq
    tree
  ];

  programs.firefox.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-configtool
      fcitx5-mozc
      fcitx5-pinyin-zhwiki
      fcitx5-rime
      fcitx5-gtk
    ];
  };

  programs.waybar.enable = true;
  programs.fish.enable = true;
}
