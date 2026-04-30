{
  pkgs,
  inputs,
  config,
  vars,
  ...
}:

let
  dataRoot = vars.storage.data.mountPoint;
  userName = vars.user.name;
  userHome = vars.user.home;
  userDataDirName = vars.storage.userDataDirName;
  dataUserDir = "${dataRoot}/${userName}";
  dataUserDataDir = "${dataUserDir}/${userDataDirName}";
  dataTeeDir = "${dataRoot}/${vars.storage.teeDirName}";
  homeDataDir = "${userHome}/${userDataDirName}";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/rust.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/pg.nix
    ../../modules/nixos/game.nix

    inputs.silentSDDM.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs vars; };
    users.${userName} = import ./home.nix;
    backupFileExtension = "backup";
  };

  networking.hostName = vars.host.name;
  networking.proxy = {
    default = vars.networking.proxy.default;
    noProxy = vars.networking.proxy.noProxy;
  };
  hardware.enableAllFirmware = true;
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options rtw89_pci disable_aspm_l1=y
    options rtw89_core disable_ps_mode=y
    options v4l2loopback video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1  '';
  virtualisation.docker.enable = true;
  users.users.${userName} = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = vars.user.groups;
  };
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };
  fileSystems."${dataRoot}" = {
    device = vars.storage.data.device;
    fsType = vars.storage.data.fsType;
    options = vars.storage.data.options;
  };
  fileSystems."${homeDataDir}" = {
    device = dataUserDataDir;
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = false;
  };
  systemd.tmpfiles.rules = [
    "d ${dataRoot} 0755 root root -"
    "d ${dataUserDir} 0755 ${userName} users -"
    "d ${dataTeeDir} 0755 ${userName} users -"
    "d ${dataUserDataDir} 0755 ${userName} users -"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  programs.niri.enable = true;
  services.desktopManager.cosmic.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libcap
    stdenv.cc.cc.lib
    zlib
    curl
    openssl
  ];

  services.guix.enable = true;

  system.stateVersion = vars.stateVersion.system;
}
