# ~/my-nix-config/modules/home-manager/desktop.nix
{
  pkgs,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./fonts.nix
    ./anyrun.nix
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    kdePackages.dolphin
    nautilus
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
