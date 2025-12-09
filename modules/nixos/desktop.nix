{ inputs, pkgs, ... }:
{

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "catppuccin-sddm";
  services.displayManager.sddm.wayland.enable = true;
  services.libinput.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "compose:super,caps:esc";

  services.udisks2.enable = true;

  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://localhost:7890";
    HTTPS_PROXY = "http://localhost:7890";
    NO_PROXY = "localhost,127.0.0.1";
  };
  environment.systemPackages = [
    inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin
    pkgs.catppuccin-sddm
    pkgs.pavucontrol
  ];

}
