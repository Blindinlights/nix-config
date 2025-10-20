{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];
  programs.noctalia-shell = {
    enable = true;

    # settings={
    #   hooks={
    #     enable=true;
    #     darkmodeChange="darkman toggle";
    #   };
    # };
  };
}
