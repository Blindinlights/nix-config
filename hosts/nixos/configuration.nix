{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/rust.nix

  ];

  networking.hostName = "nixos";

  users.users.blindinlights = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  programs.niri.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.blindinlights = import ./home.nix;
  home-manager.backupFileExtension = "hm-bak";

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";
}
