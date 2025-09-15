{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "FiraCode" ]; }
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    source-han-sans
    source-han-serif
    source-code-pro
    noto-fonts-emoji

  ];
}
