{
  lib,
  pkgs,
  vars,
  ...
}:
let
  modulesPath = ./niri;
  browserDesktop = "firefox-nightly.desktop";
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
    # mako
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
      "text/html" = [ browserDesktop ];
      "x-scheme-handler/http" = [ browserDesktop ];
      "x-scheme-handler/https" = [ browserDesktop ];
      "x-scheme-handler/about" = [ browserDesktop ];
      "x-scheme-handler/unknown" = [ browserDesktop ];
      "application/xhtml+xml" = [ browserDesktop ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ]; # mkv
      "video/webm" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ]; # mov
      "video/x-msvideo" = [ "vlc.desktop" ]; # avi
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
      lat = vars.location.lat;
      lng = vars.location.lng;
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
