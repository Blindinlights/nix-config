{ pkgs, vars, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
      };
      user.name = vars.user.git.name;
      user.email = vars.user.git.email;
      init.defaultBranch = "main";
      pull.rebase = false;
      color.ui = true;
    };

  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = vars.user.git.name;
      user.email = vars.user.git.email;
    };
  };
  programs.jjui.enable = true;
  home.packages = [
    pkgs.prek
  ];
}
