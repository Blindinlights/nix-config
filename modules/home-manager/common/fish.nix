# ~/my-nix-config/modules/home-manager/fish.nix
{
  pkgs,
  lib,
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
      __fish_colorize_short_id = {
        description = "Render a short id with segmented colors";
        body = ''
          set -l first_half $argv[1]
          set -l second_half $argv[2]

          if test (count $argv) -lt 2
            set -l short_id (string sub -s 1 -l 8 -- $first_half)
            set first_half (string sub -s 1 -l 4 -- $short_id)
            set second_half (string sub -s 5 -l 4 -- $short_id)
          end

          set_color brred
          echo -n $first_half

          if test -n "$second_half"
            set_color bryellow
            echo -n $second_half
          end

          set_color normal
        '';
      };
      __fish_jj_prompt = {
        description = "Render jj repository info";
        body = ''
          command -sq jj; or return 1
          command jj root --ignore-working-copy >/dev/null 2>&1; or return 1

          set -l metadata (
            command jj log \
              -r @ \
              --ignore-working-copy \
              --no-pager \
              --no-graph \
              -T 'if(bookmarks, bookmarks, "-") ++ "\t" ++ change_id.shortest(8).prefix() ++ "\t" ++ change_id.shortest(8).rest() ++ "\t" ++ if(empty, "1", "0") ++ "\t" ++ if(conflict, "1", "0") ++ "\t" ++ if(description.first_line(), description.first_line(), "-")' \
              2>/dev/null | string trim
          )

          test -n "$metadata"; or return 1

          set -l fields (string split \t -- $metadata)
          set -l bookmarks $fields[1]
          set -l short_id_prefix $fields[2]
          set -l short_id_rest $fields[3]
          set -l is_empty $fields[4]
          set -l has_conflict $fields[5]
          set -l summary $fields[6]

          set_color --bold brmagenta
          echo -n " jj"

          set_color brblack
          echo -n ":"

          if test "$bookmarks" != "-"
            set_color --bold brgreen
            echo -n $bookmarks

            set_color white
            echo -n "@"
          end

          __fish_colorize_short_id $short_id_prefix "$short_id_rest"

          if test "$is_empty" = "1"
            set_color yellow
            echo -n " empty"
          end

          if test "$has_conflict" = "1"
            set_color brred
            echo -n " conflict"
          end

          set_color brblack
          if test "$summary" != "-"
            echo -n " " (string sub -s 1 -l 28 -- $summary)
          else
            echo -n " no-desc"
          end

          set_color normal
        '';
      };
      __fish_git_prompt = {
        description = "Render git repository info";
        body = ''
          command -sq git; or return 1
          command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

          set -l ref (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
          set -l detached 0
          if test -z "$ref"
            set detached 1
            set ref (command git rev-parse --short HEAD 2>/dev/null)
          end

          set -l staged 0
          set -l unstaged 0
          set -l untracked 0

          for line in (command git status --porcelain --ignore-submodules=dirty 2>/dev/null)
            set -l index_state (string sub -s 1 -l 1 -- $line)
            set -l worktree_state (string sub -s 2 -l 1 -- $line)

            if test "$index_state" = "?"
              set untracked (math $untracked + 1)
              continue
            end

            if test "$index_state" != " "
              set staged (math $staged + 1)
            end

            if test "$worktree_state" != " "
              set unstaged (math $unstaged + 1)
            end
          end

          set_color --bold brblue
          echo -n " git"

          set_color brblack
          echo -n ":"

          if test "$detached" = "1"
            __fish_colorize_short_id $ref
          else
            set_color --bold green
            echo -n $ref
          end

          if test $staged -gt 0
            set_color brgreen
            echo -n " +$staged"
          end

          if test $unstaged -gt 0
            set_color yellow
            echo -n " ~$unstaged"
          end

          if test $untracked -gt 0
            set_color brred
            echo -n " ?$untracked"
          end

          set_color normal
        '';
      };
      fish_prompt = {
        body = ''
          if test "$argv[1]" = --final-rendering
            set_color --bold brcyan
            echo -n '> '
            set_color normal
            return
          end

          set_color --bold brcyan
          echo -n (prompt_pwd)

          __fish_jj_prompt; or __fish_git_prompt

          set_color --bold brcyan
          echo
          echo -n '> '

          set_color normal
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
      set -g fish_transient_prompt 1

      proxy_on >/dev/null 2>&1

      atuin init fish | sed "s/-k up/up/g" | source 
    '';

  };

}
