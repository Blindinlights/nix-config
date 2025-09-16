{
  pkgs,
  ...
}:

{
  # 导入此主机所需的模块
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop.nix
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
