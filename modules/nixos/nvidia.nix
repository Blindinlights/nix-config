{ ... }:
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware.nvidia.open = true;

  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:4@0:0:0";
  };
}
