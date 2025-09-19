{ ... }:
{

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.libinput.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.udisks2.enable = true;

  systemd.services.nix-daemon.environment = {
    HTTP_PROXY = "http://localhost:7890";
    HTTPS_PROXY = "http://localhost:7890";
    NO_PROXY = "localhost,127.0.0.1";
  };

}
