{ pkgs, ... }:

{
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
