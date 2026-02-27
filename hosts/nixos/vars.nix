{
  system = "x86_64-linux";

  host = {
    name = "nixos";
  };

  user = {
    name = "blindinlights";
    home = "/home/blindinlights";
    groups = [
      "video"
      "wheel"
      "networkmanager"
    ];
    git = {
      name = "blindinlights";
      email = "chenyutong007@gmail.com";
    };
  };

  stateVersion = {
    system = "25.05";
    home = "25.05";
  };

  networking = {
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    proxy = {
      default = "http://127.0.0.1:7890";
      noProxy = "127.0.0.1,localhost";
      env = {
        http = "http://localhost:7890";
        https = "http://localhost:7890";
        noProxy = "localhost,127.0.0.1";
      };
    };
    xkb = {
      layout = "us";
      options = "compose:super,caps:esc";
    };
  };

  locale = {
    timeZone = "Asia/Shanghai";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  storage = {
    data = {
      mountPoint = "/data";
      device = "/dev/disk/by-uuid/29239a17-d46b-4317-b36a-70c003fef68e";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };
    userDataDirName = "Data";
    teeDirName = "TEE";
  };

  hardware = {
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:6:0:0";
  };

  location = {
    lat = 30.0;
    lng = 120.0;
  };

  postgres = {
    ensureDatabases = [ "ironclaw" ];
  };
}
