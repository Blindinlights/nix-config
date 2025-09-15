# ~/my-nix-config/modules/home-manager/desktop.nix
{ config, lib, pkgs, ... }:

{
  imports=[
    ../desktop.nix
    ../fonts.nix
  ];
  home.packages = with pkgs; [
    kdePackages.dolphin
    swaylock
    mako
    anyrun

    bibata-cursors
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  programs.waybar.enable = true;
}
