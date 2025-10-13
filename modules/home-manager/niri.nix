{
  lib,
  pkgs,
  ...
}:
let
   dark=../../wallpapers/dark.jpeg;
   light=../../wallpapers/light.jpeg;
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
    # xdg-desktop-portal
    # xdg-desktop-portal-cosmic
    kdePackages.okular
    cosmic-files 
    swaylock
    swayidle
    mako
    swww
    exfatprogs
    ntfs3g
    bibata-cursors
    xwayland-satellite
    brightnessctl
    playerctl
      ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  services.swww.enable = true;

  xdg.portal={
    enable = true;
    extraPortals = [
    pkgs.xdg-desktop-portal-cosmic
    pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default="*";
  };

  home.file.".config/niri/config.kdl" = {
    source = ./dotfiles/niri.kdl;
  };
  
  services.darkman={
    enable=true;
    darkModeScripts={
        wallpaper=''${pkgs.swww}/bin/swww img ${dark} '';
    };
    lightModeScripts ={
        wallpaper=''${pkgs.swww}/bin/swww img ${light}'';
    };
    settings={
      
    };
  };
}
