{config, inputs, lib, pkgs, ... }:
{

  imports = lib.mapAttrsToList (
    name: value:
    if value == "regular" && lib.hasSuffix ".nix" name then ./. + "/desktop/${name}" else null
  ) (builtins.readDir ./desktop);

  home.packages = with pkgs; [
    btop
    qq
    appimage-run
    flclash
    # clash-verge-rev
    wl-clipboard
    imv
    vlc
    wemeet
    ffmpeg
    obs-studio
    yt-dlp
    sniffnet
    thunderbird
    # (cherry-studio.override { electron_38 = pkgs.electron_39; })
    sillytavern
    ayugram-desktop
    libreoffice
    # google-chrome
    tor-browser
    # wechat
    papirus-icon-theme
  ]++[
    inputs.browser-previews.packages.${pkgs.stdenv.hostPlatform.system}.google-chrome-dev
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
    gtk4.theme = config.gtk.theme;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

}
