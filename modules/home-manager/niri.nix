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
    cosmic-term
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
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      niri = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/http" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/https" = [ "firefox-nightly.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
    };
    associations.removed = {
      "application/pdf" = [ "com.google.Chrome.desktop" ];
    };
  };
  home.file.".config/niri/config.kdl" = {
    source = ./dotfiles/niri.kdl;
  };

  services.darkman = {
    enable = true;
    settings = {
      lat = 30.0;
      lng = 120.0;
      usegeoclue = false;
    };
    darkModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
    };
    lightModeScripts = {
      gtk-theme = ''
        ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
    };
  };
}
