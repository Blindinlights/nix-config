{ config, pkgs, ... }:

{
  home.packages = [ pkgs.git ]; # 也可以在这里安装 git

  programs.git = {
    enable = true;
    userName = "Yutong Chen";
    userEmail = "chenyutong007@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "helix";
    };
  };
}
