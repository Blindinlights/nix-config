# hosts/nixos/configuration.nix
{ config, pkgs, inputs, ... }:

{
  # 导入此主机所需的模块
  imports = [
    ./hardware-configuration.nix # 硬件配置 [cite: 4]
    ../../modules/nixos/base.nix  # 导入我们创建的系统基础模块
  ];

  networking.hostName = "nixos";

  users.users.blindinlights = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  programs.waybar.enable = true;
  programs.fish.enable = true;
  programs.niri.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.blindinlights = import ./home.nix;
  home-manager.backupFileExtension = "hm-bak";
  # 系统状态版本，非常重要！
  system.stateVersion = "25.05";
}
