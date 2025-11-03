{
  lib,
  pkgs,
  ...
}:
let
  modulesPath = ./niri;
  moduleFiles = lib.mapAttrsToList (
    name: value:
    if value == "regular" && lib.hasSuffix ".nix" name then "${modulesPath}/${name}" else null
  ) (builtins.readDir modulesPath);

in
{
  imports = [
    ./desktop.nix
    ./noctalia.nix
  ]
  ++ moduleFiles;
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.okular
    cosmic-files
    swaylock
    swayidle
    mako
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
  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-cosmic
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  home.file.".config/niri/config.kdl" = {
    source = ./dotfiles/niri.kdl;
  };

  services.darkman = {
    enable = true;
    darkModeScripts = {
    };
    lightModeScripts = {
    };
  };
}
