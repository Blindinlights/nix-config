{
  pkgs,
  vars,
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
  nixpkgs.overlays = [
    (import ../../overlays/cherry-studio.nix)
  ];

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  security.sudo.wheelNeedsPassword = false;
  programs.fish.enable = true;
  networking = {
    nameservers = vars.networking.nameservers;
  };

  time.timeZone = vars.locale.timeZone;
  i18n.defaultLocale = vars.locale.defaultLocale;
  i18n.supportedLocales = vars.locale.supportedLocales;

  services.openssh.enable = true;

  # nix.settings.substituters = [
  #   "https://mirror.sjtu.edu.cn/nix-channels/store"
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  # ];
  nix.settings.auto-optimise-store = true;

}
