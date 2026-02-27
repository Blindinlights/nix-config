{
  pkgs,
  flakeRoot,
  inputs,
  vars,
  ...
}:
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/niri.nix
    ../../modules/home-manager/development.nix
  ];
  home.username = vars.user.name;
  home.homeDirectory = vars.user.home;
  home.stateVersion = vars.stateVersion.home;
}
