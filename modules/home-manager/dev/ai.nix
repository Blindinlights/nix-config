{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # gemini-cli
    codex
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
    # claude-code
    opencode
  
  ];

}
