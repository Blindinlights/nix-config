# ~/my-nix-config/modules/home-manager/fish.nix
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    generateCompletions = true
    shellAbbrs = {
      # 文件列表
      l = "lsd -l";
      la = "lsd -a";
      lla = "lsd -la";
      lt = "lsd --tree";
      # 开发工具
      gcl = "cd ~/Repos && git clone";
      hxs = "sudo hx";
      cls = "clear";
      vi = "nvim";
      vim = "nvim";
      # cat = "bat --style=plain";
      du = "dust";
      "cd.." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      gh = "github";
    };

    functions = {
      y = {
        description = "Yazi file manager";
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      mkcd = {
        description = "Create and change directory";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };

      gp = {
        description = "Git push with remote branch creation";
        body = ''
          set -l branch (git rev-parse --abbrev-ref HEAD)
          git push -u origin $branch $argv
        '';
      };

      proxy_on = {
        description = "Enable proxy";
        body = ''
          set -gx http_proxy http://127.0.0.1:7890
          set -gx https_proxy http://127.0.0.1:7890
        '';
      };
      proxy_off = {
        description = "Disable proxy";
        body = ''
          set -e http_proxy
          set -e https_proxy
        '';
      };
    };

    interactiveShellInit = ''
      # 默认开启代理
      proxy_on

      # 初始化 ssh-agent
      eval (ssh-agent -c) >/dev/null 2>&1

      # starship, atuin 等提示符工具的初始化
      # 如果你用 Home Manager 安装了它们, 可以使用以下方式:
      # starship init fish | source
      # atuin init fish | source
    '';

    # 修改 PATH 变量
    # Home Manager 会自动将 home.packages 中的包装入 PATH
    # 这里只添加额外的、非 Nix 管理的路径
    # extraPath = [
    #   "$HOME/.local/bin"
    #   "/home/blindinlights/.lmstudio/bin"
    # ];
  };
}
