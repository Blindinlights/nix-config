{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    # noctalia-shell
    pywalfox-native
  ];

  home.sessionVariables = {
    QS_ICON_THEME = "Papirus";
  };
  programs.noctalia-shell = {
    enable = true;
  };
}
