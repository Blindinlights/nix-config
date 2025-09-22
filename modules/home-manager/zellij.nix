{ ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      # default_layout = "compact";
      # simplified_ui = true;
      show_startup_tips = false;
      # keybinds = {
      #   # unbind = [ "Ctrl s" ];

      # };

    };
  };
}
