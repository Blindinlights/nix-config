{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gemini-cli
    codex
    aider-chat-full
    claude-code
    # claude-code-router
  
  ];

}
