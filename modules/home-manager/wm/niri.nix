# ~/my-nix-config/modules/home-manager/desktop.nix
{ config, lib, pkgs, ... }:

{
  imports=[
    ../desktop.nix
    ../fonts.nix
  ]
  home.packages = with pkgs; [
    kdePackages.dolphin
    swaylock
    mako
    anyrun
  ];
  programs.waybar.enable = true;
}
