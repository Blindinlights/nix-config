{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/wm/niri.nix
    ../../modules/home-manager/development/development.nix

  ];
  home.username = "blindinlights";
  home.homeDirectory = "/home/blindinlights";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    lmstudio
  ];
}
