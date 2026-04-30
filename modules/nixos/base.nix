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
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
  ];

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  security.sudo.wheelNeedsPassword = false;
  environment.shells = [ pkgs.nushell ];
  programs.fish.enable = true;
  programs.nh = {
    enable = true;
    flake = "/home/${vars.user.name}/nix-config";
  };
  networking = {
    nameservers = vars.networking.nameservers;
  };

  time.timeZone = vars.locale.timeZone;
  i18n.defaultLocale = vars.locale.defaultLocale;
  i18n.supportedLocales = vars.locale.supportedLocales;

  services.openssh.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.fwupd.enable = true;
  zramSwap.enable = true;

  # nix.settings.substituters = [
  #   "https://mirror.sjtu.edu.cn/nix-channels/store"
  #   "https://mirrors.ustc.edu.cn/nix-channels/store"
  # ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = with pkgs; [
    nh
    nvd
  ];

}
