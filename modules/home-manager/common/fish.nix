# ~/my-nix-config/modules/home-manager/fish.nix
{
  pkgs,
  vars,
  ...
}:

{
  # home.activation.configure-tide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
  # '';
  home.packages = [
    pkgs.fish-lsp
  ];

  programs.fish = {
    enable = true;
    generateCompletions = true;
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
      ls = "lsd";
      l = "lsd -l";
      la = "lsd -a";
      lla = "lsd -la";
      lt = "lsd --tree";
      gcl = "cd ~/Repos && git clone";
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

    functions = {
      fish_greeting = {
        description = "fish greeting";
        body = "";
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
          set -l proxy_host 127.0.0.1
          set -l proxy_port 7890

          if not ${pkgs.netcat}/bin/nc -z $proxy_host $proxy_port >/dev/null 2>&1
            return 1
          end

          set -gx http_proxy ${vars.networking.proxy.default}
          set -gx https_proxy ${vars.networking.proxy.default}
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
      proxy_on >/dev/null 2>&1

      atuin init fish | sed "s/-k up/up/g" | source 
    '';

  };

}
