{
  pkgs,
  inputs,
  config,
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
    ../../modules/nixos/pg.nix
    # ../../secrets/secrets.nix
  ];

  networking.hostName = "nixos";
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost";
  hardware.enableAllFirmware = true;
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options rtw89_pci disable_aspm_l1=y
    options rtw89_core disable_ps_mode=y
    options v4l2loopback video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1  '';
  # boot.kernel.sysctl = {
  #   "net.core.default_qdisc" = "fq";
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  # };
  virtualisation.waydroid.enable = true;
  virtualisation.docker.enable = true;
  users.users.blindinlights = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "video"
      "wheel"
      "networkmanager"
    ];
  };
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
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
    "d /data/TEE 0755 blindinlights users -"
    "d /data/blindinlights/Data 0755 blindinlights users -"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  programs.niri.enable = true;
  services.desktopManager.cosmic.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.blindinlights = {
    imports = [ ./home.nix ];
  };

  home-manager.backupFileExtension = "hm-bak";

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";
}
