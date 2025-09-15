# ~/my-nix-config/modules/home-manager/common.nix
{ config, lib, pkgs, ... }:

{
  # 只保留在任何机器上都可能用到的核心CLI工具
  home.packages = with pkgs; [
    tree
    yazi
    lsd
    fd
    ripgrep
    bat
    dust
    helix
    zellij
  ];

}
