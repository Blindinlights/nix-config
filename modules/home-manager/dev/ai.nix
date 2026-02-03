{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gemini-cli
    codex
    claude-code
    opencode
    amp-cli
    antigravity
    # claude-code-router
  
  ];

}
