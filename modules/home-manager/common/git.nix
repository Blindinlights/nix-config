{ ... }:

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
      user.name = "blindinlights";
      user.email = "chenyutong007@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
      color.ui = true;
    };

  };
}
