{ ... }:

{
  services.mako = {
    enable = true;

    # 默认样式
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      backgroundColor = "#1e1e2eff"; # Catppuccin Macchiato Base
      textColor = "#cdd6f4ff"; # Catppuccin Macchiato Text
      borderColor = "#89b4faff"; # Catppuccin Macchiato Blue

      borderSize = 2;
      borderRadius = 8;
      padding = "10";
      width = 320;

      "actionable=true" = {
        anchor = "top-right";
      };
    };
  };
}
