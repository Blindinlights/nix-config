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

    # extraConfig 可以用来编写更复杂的条件样式
    extraConfig = ''
      [urgency=high]
      background-color=#ed8796
      border-color=#ed8796
      text-color=#1e1e2e
    '';
  };
}
