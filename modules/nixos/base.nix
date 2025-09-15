# modules/nixos/base.nix
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 启用 Flakes 和 nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # 引导加载程序
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  security.sudo.wheelNeedsPassword = false;
  programs.fish.enable = true;
  services.udisks2.enable = true;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.openssh.enable = true;

  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  nix.settings.auto-optimise-store = true;
}
