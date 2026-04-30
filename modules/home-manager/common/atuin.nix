{ ... }:
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = false;
    enableNushellIntegration = true;
    daemon.enable = true;
  };
}
