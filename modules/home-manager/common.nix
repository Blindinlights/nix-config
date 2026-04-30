{
  lib,
  pkgs,
  ...
}:
let
  modulesPath = ./common;
  moduleFiles = lib.filter (path: path != null) (
    lib.mapAttrsToList (
      name: value:
      if value == "regular" && lib.hasSuffix ".nix" name then modulesPath + "/${name}" else null
    ) (builtins.readDir modulesPath)
  );
in
{
  imports = moduleFiles;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.shell.enableNushellIntegration = true;
  home.packages = with pkgs; [
    tree
    lsd
    fd
    ripgrep
    bat
    dust
    zip
    unzip
    github-cli
    lazygit
    gh

    nixfmt
    stow
    chezmoi
    aria2
    ast-grep
    just
    fzf
    killall
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };
}
