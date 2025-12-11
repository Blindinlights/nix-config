{ pkgs, ... }:
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  hardware.nvidia.prime = {
    # sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:6:0:0";
    offload={
      enable = true;
      enableOffloadCmd = true;
    };
  };
  environment.systemPackages = [
    pkgs.cudatoolkit
    pkgs.cudaPackages.cudnn
    pkgs.cudaPackages.cuda_cudart
    
  ];
}
