{ ... }:

{
  programs.git = {
    enable = true;
    # 替换成你的 Git 用户名和邮箱
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

    # 额外的 Git 配置，对应 .gitconfig 文件中的内容
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false; # 合并时默认使用 merge 而不是 rebase
      color.ui = true; # 开启颜色
      # GPG 签名配置 (可选)
      # commit.gpgsign = true;
    };

    # GPG 签名密钥 (可选)
    # 如果启用了 gpgsign，你需要在这里指定你的 GPG 密钥 ID
    # signing = {
    #   key = "YOUR_GPG_KEY_ID";
    #   signByDefault = true;
    # };
  };
}
