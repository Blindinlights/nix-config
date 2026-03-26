{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    source-han-mono
    source-code-pro
    noto-fonts-color-emoji
    corefonts

  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans CJK SC"
      "Source Han Sans SC"
    ];

    serif = [
      "Noto Serif CJK SC"
      "Source Han Serif SC"
    ];

    monospace = [
      "Source Code Pro"
      "JetBrains Mono"
      "Fira Code"
      "Source Han Mono SC"
      "Noto Sans Mono CJK SC"
    ];
  };
}
