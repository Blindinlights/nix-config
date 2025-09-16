# ~/my-nix-config/modules/home-manager/desktop.nix
{
  pkgs,
  ...
}:

{
  imports = [
    ../desktop.nix
    ../fonts.nix
    ./anyrun.nix
  ];
  home.packages = with pkgs; [
    kdePackages.dolphin
    swaylock
    swayidle
    mako
    swww
    exfatprogs
    ntfs3g
    bibata-cursors
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  programs.waybar.enable = true;
}
