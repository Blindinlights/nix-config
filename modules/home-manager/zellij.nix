{ ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "compact";
      simplified_ui = true;

      keybinds = {
        unbind = [ "Ctrl s" ];

      };

    };
  };
}
