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
    direnv
    nix-direnv
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
