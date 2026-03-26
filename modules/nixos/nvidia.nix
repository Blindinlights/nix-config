{
  config,
  pkgs,
  vars,
  ...
}:

{
  hardware.graphics = {

    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
  };

  hardware.nvidia.prime = {
    nvidiaBusId = vars.hardware.nvidiaBusId;
    amdgpuBusId = vars.hardware.amdgpuBusId;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
  environment.systemPackages = [
    # pkgs.cudatoolkit
    # pkgs.cudaPackages.cudnn
    # pkgs.cudaPackages.cuda_cudart

  ];
}
