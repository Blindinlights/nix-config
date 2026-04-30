{
  pkgs,
  vars,
  ...
}:

{
  programs.carapace = {
    enable = true;
    enableFishIntegration = false;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;

    settings = {
      show_banner = false;
      completions.external = {
        enable = true;
        max_results = 200;
      };
    };

    shellAliases = {
      diff-sys = "nix shell nixpkgs#nvd --command nvd diff /run/booted-system /run/current-system";
      nr = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
      j = "jj";
      js = "jj status";
      jl = "jj log";
      jd = "jj diff";
      jn = "jj new";
      jc = "jj commit";
      jds = "jj describe";
      je = "jj edit";
      jr = "jj rebase";
      jsq = "jj squash";
      jp = "jj git push";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls -a **/*";
      hxs = "sudo hx";
      cls = "clear";
      vi = "nvim";
      vim = "nvim";
      grep = "rg";
      du = "dust";
      "cd.." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      gh = "github";
    };

    extraEnv = ''
      $env.EDITOR = "hx"
      $env.VISUAL = "hx"
    '';

    extraConfig = ''
      def mkcd [dir: path] {
        mkdir $dir
        cd $dir
      }

      def gp [...args: string] {
        let branch = (git rev-parse --abbrev-ref HEAD | str trim)
        git push -u origin $branch ...$args
      }

      def gcl [...args: string] {
        cd ~/Repos
        git clone ...$args
      }

      def proxy_on [] {
        let proxy_host = "127.0.0.1"
        let proxy_port = 7890
        let probe = (${pkgs.netcat}/bin/nc -z $proxy_host $proxy_port | complete)

        if $probe.exit_code != 0 {
          return
        }

        $env.http_proxy = "${vars.networking.proxy.default}"
        $env.https_proxy = "${vars.networking.proxy.default}"
      }

      def proxy_off [] {
        hide-env -i http_proxy
        hide-env -i https_proxy
      }

      proxy_on
    '';
  };
}
