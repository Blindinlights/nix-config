{ lib, pkgs, ... }:
let
  modulesPath = ./dev;
  moduleFiles = lib.mapAttrsToList (
    name: value:
    if value == "regular" && lib.hasSuffix ".nix" name then "${modulesPath}/${name}" else null
  ) (builtins.readDir modulesPath);

in
{
  imports = [

  ]
  ++ moduleFiles;

}
