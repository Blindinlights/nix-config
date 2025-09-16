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

}
