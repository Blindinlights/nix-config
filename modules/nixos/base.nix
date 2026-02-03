{
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  security.sudo.wheelNeedsPassword = false;
  programs.fish.enable = true;
  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  services.openssh.enable = true;

  # nix.settings.substituters = [
  #   "https://mirror.sjtu.edu.cn/nix-channels/store"
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  # ];
  nix.settings.auto-optimise-store = true;

}
