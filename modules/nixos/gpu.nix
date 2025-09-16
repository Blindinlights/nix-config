# modules/nixos/gpu.nix
{ config, ... }:

{

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;
    powerManagement.persistenceMode = true;

    prime = {
      sync.enable = true;

      offload = {
        enable = true;
        enableOffloadCmd = true; # 允许使用 `prime-run` 命令
      };

      # 为 AMD 集成显卡和 NVIDIA 独立显卡设置正确的 PCI 总线 ID
      amdgpuBusId = "06:00.0";
      nvidiaBusId = "01:00.0";
    };

    # 安装驱动包
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # 配置 OpenGL 以支持混合显卡
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
