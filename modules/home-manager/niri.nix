{
  lib,
  pkgs,
  ...
}:
let
   modulesPath =./niri;
   moduleFiles =
    lib.mapAttrsToList (name: value:
      if value == "regular" && lib.hasSuffix ".nix" name
      then  "${modulesPath}/${name}"
      else null
    ) (builtins.readDir modulesPath);
in 
{
  imports = [
    ./desktop.nix
  ]++moduleFiles;
  home.packages = with pkgs; [
    kdePackages.dolphin
    # nautilus
    cosmic-files 
    swaylock
    swayidle
    mako
    swww
    exfatprogs
    ntfs3g
    bibata-cursors
    xwayland-satellite
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  services.swww.enable = true;
  home.file.".config/niri/config.kdl" = {
    source = ./dotfiles/niri.kdl;
  };

}
