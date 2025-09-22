# ~/my-nix-config/modules/home-manager/desktop.nix
{ pkgs, ... }:

{
  imports = [
    ./wezterm.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    btop
    qq
    flclash
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
