{ inputs, pkgs, vars, ... }:
{

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.enable = true;
  services.displayManager.defaultSession = "niri";
  services.displayManager.sddm = {
    enable = true;
  };
  programs.silentSDDM = {
    enable = true;
    theme = "default";
  };

  services.libinput.enable = true;

  services.xserver.xkb.layout = vars.networking.xkb.layout;
  services.xserver.xkb.options = vars.networking.xkb.options;

  services.udisks2.enable = true;

  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = vars.networking.proxy.env.http;
    HTTPS_PROXY = vars.networking.proxy.env.https;
    NO_PROXY = vars.networking.proxy.env.noProxy;
  };
  environment.systemPackages = [
    inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin
    pkgs.catppuccin-sddm
    pkgs.pavucontrol
  ];

}
