{ lib,pkgs, ... }:
{

  imports =
    lib.mapAttrsToList (name: value:
      if value == "regular" && lib.hasSuffix ".nix" name
      then ./. + "/desktop/${name}"
      else null
    ) (builtins.readDir ./desktop);

  home.packages = with pkgs; [
    btop
    qq
    # flclash
    # sparkle
    clash-nyanpasu
    # gui-for-clash
    clash-verge-rev
    wl-clipboard
    vlc

    r2modman
    ffmpeg
    yt-dlp
    sniffnet
    thunderbird
    cherry-studio
    sillytavern
    qcm
  ];

  programs.firefox.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-configtool
      fcitx5-mozc
      fcitx5-pinyin-zhwiki
      fcitx5-rime
      fcitx5-gtk
    ];
  };

}
