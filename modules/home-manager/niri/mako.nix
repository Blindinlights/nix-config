{ ... }:

{
  services.mako = {
    enable = true;

    # 默认样式
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      background-color = "#1e1e2eff";
      text-color = "#cdd6f4ff";
      border-color = "#89b4faff";

      border-size = 2;
      border-radius = 8;
      padding = "10";
      width = 320;
      default-timeout=5000;
      icons=true;

      "actionable=true" = {
        anchor = "top-right";
      };
    };
  };
}
