{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    package = inputs.firefox.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin;
    languagePacks = [
      "en-US"
      "zh-CN"
    ];
  };
}
