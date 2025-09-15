# hosts/nixos/home.nix
{ pkgs, ... }:

{
  # 导入通用的 home-manager 模块
  imports = [
    ../../modules/home-manager/common.nix
  ];

  # 设置用户名和家目录
  home.username = "blindinlights";
  home.homeDirectory = "/home/blindinlights";

  # 必须设置 stateVersion
  home.stateVersion = "25.05";
}
