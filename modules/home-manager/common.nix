{ pkgs, ... }:

{
  imports = [
    ./zellij.nix
    ./helix.nix
    ./atuin.nix
  ];

  home.packages = with pkgs; [
    tree
    yazi
    lsd
    fd
    ripgrep
    bat
    dust
    direnv
    ast-grep
    just
    fzf
    killall
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
