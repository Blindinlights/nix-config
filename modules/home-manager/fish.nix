# ~/my-nix-config/modules/home-manager/fish.nix
{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # 简单的欢迎语，对应 function fish_greeting

    # 环境变量，对应 set -gx
    # environment = {
    #   DEBUGINFOD_URLS = "https://debuginfod.archlinux.org";
    #   EDITOR = "${pkgs.helix}/bin/hx"; # 使用 Nix 包路径确保正确
    #   # MANPAGER = "bat -l man"; # 如果需要可以取消注释
    #   PNPM_HOME = "$HOME/.local/share/pnpm";
    #   BUN_INSTALL = "$HOME/.bun";
    # };

    # 别名，对应 alias
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

    # 自定义函数
    functions = {
      # Yazi 文件管理器
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

      # 创建并进入目录
      mkcd = {
        description = "Create and change directory";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };

      # Git push
      gp = {
        description = "Git push with remote branch creation";
        body = ''
          set -l branch (git rev-parse --abbrev-ref HEAD)
          git push -u origin $branch $argv
        '';
      };

      # 代理开关
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

    # 交互式 Shell 启动时执行的代码
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

  # 如果 ls 命令也想用 lsd, 可以这样设置
  # programs.lsd.enable = true;
  # programs.lsd.aliases.ls = "lsd";
}
