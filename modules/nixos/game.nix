{ inputs, ... }:
{
  imports = [ inputs.aagl.nixosModules.default ];
  nix.settings = inputs.aagl.nixConfig; # Set up Cachix
  programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules

}
