# ~/my-nix-config/modules/home-manager/fish.nix
{ pkgs, lib, ... }:

{
  home.activation.configure-tide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
  '';
  home.packages = [
    pkgs.fish-lsp
  ];
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        inherit (tide) src;
      }
    ];
    generateCompletions = true;
    shellAliases = {
      diff-sys = "nix shell nixpkgs#nvd --command nvd diff /run/booted-system /run/current-system";
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
      proxy_on

      atuin init fish | sed "s/-k up/up/g" | source 

      eval (ssh-agent -c) >/dev/null 2>&1
    '';

  };

}
