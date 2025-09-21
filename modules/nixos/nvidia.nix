{ config, pkgs, ... }:
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware.nvidia = {
    open = true;
  };

  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:4@0:0:0";
  };

  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages = prev.linuxPackages.extend (
        final: prev: {
          nvidia_x11_open = prev.nvidia_x11_open.overrideAttrs {
            src = /tmp/NVIDIA-Linux-x86_64-580.82.09.run;
          };
        }
      );
    })
  ];
}
