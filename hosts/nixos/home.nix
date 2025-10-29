{flakeRoot, inputs, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/niri.nix
    ../../modules/home-manager/development.nix
  ];
  home.username = "blindinlights";
  home.homeDirectory = "/home/blindinlights";
  home.stateVersion = "25.05";
}
