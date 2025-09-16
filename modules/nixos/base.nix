# modules/nixos/base.nix
{
  ...
}:

{
  # 启用 Flakes 和 nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  security.sudo.wheelNeedsPassword = false;
  programs.fish.enable = true;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  services.openssh.enable = true;

  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  nix.settings.auto-optimise-store = true;
}
