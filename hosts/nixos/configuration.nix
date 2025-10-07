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
    ../../modules/nixos/nvidia.nix
    # ../../secrets/secrets.nix
  ];

  networking.hostName = "nixos";
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost";
  users.users.blindinlights = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/29239a17-d46b-4317-b36a-70c003fef68e";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/home/blindinlights/Data" = {
    device = "/data/blindinlights/Data";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = false;
  };
  systemd.tmpfiles.rules = [
    "d /data 0755 root root -"
    "d /data/blindinlights 0755 blindinlights users -"
    "d /data/blindinlights/Data 0755 blindinlights users -"
  ];

  programs.niri.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.blindinlights = import ./home.nix;
  home-manager.backupFileExtension = "hm-bak";

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";
}
