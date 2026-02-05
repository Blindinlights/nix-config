{lib, pkgs, ... }:
let
   modulesPath =./common;
   moduleFiles =
    lib.mapAttrsToList (name: value:
      if value == "regular" && lib.hasSuffix ".nix" name
      then  "${modulesPath}/${name}"
      else null
    ) (builtins.readDir modulesPath);
in 
{
  imports = [

  ]++moduleFiles;

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

    nixfmt
    stow
    chezmoi
    # direnv
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
