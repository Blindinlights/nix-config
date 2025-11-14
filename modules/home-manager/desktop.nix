{ lib, pkgs, ... }:
{

  imports = lib.mapAttrsToList (
    name: value:
    if value == "regular" && lib.hasSuffix ".nix" name then ./. + "/desktop/${name}" else null
  ) (builtins.readDir ./desktop);

  home.packages = with pkgs; [
    btop
    qq
    flclash
    # clash-verge-rev
    wl-clipboard
    vlc

    ffmpeg
    yt-dlp
    sniffnet
    thunderbird
    cherry-studio
    sillytavern
    ayugram-desktop
    libreoffice
    google-chrome
    tor-browser
    # qcm
    # netease-cloud-music-gtk
    papirus-icon-theme
  ];

  programs.firefox.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      qt6Packages.fcitx5-configtool
      fcitx5-mozc
      fcitx5-pinyin-zhwiki
      fcitx5-rime
      fcitx5-gtk
    ];
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

}
