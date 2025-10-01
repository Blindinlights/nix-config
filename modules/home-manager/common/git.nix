{ ... }:

{
  programs.git = {
    enable = true;
    userName = "blindinlights";
    userEmail = "chenyutong007@gmail.com";

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      last = "log -1 HEAD";
      unstage = "reset HEAD --";
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      color.ui = true;
    };

  };
}
