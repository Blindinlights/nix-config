{ pkgs, ... }:

let
  starshipFishShell = [
    "${pkgs.fish}/bin/fish"
    "--no-config"
  ];

  colorizeShortId = ''
    function __starship_colorize_short_id
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
    end
  '';
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
    extraPackages = with pkgs; [
      git
      jujutsu
    ];

    settings = {
      add_newline = false;
      command_timeout = 1000;
      scan_timeout = 10;
      format = "$directory\${custom.jj}\${custom.git}$line_break$character";
      right_format = "$python$rust$nodejs";

      directory = {
        format = "[$path]($style)";
        style = "bold cyan";
        truncation_length = 1;
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 1;
      };

      character = {
        format = "$symbol ";
        success_symbol = "[>](bold cyan)";
        error_symbol = "[>](bold cyan)";
        vimcmd_symbol = "[>](bold cyan)";
        vimcmd_visual_symbol = "[>](bold cyan)";
        vimcmd_replace_symbol = "[>](bold cyan)";
        vimcmd_replace_one_symbol = "[>](bold cyan)";
      };

      python = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold yellow";
        symbol = "🐍";
      };

      rust = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold red";
        symbol = "🦀";
      };

      nodejs = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold green";
        symbol = "⬢";
        detect_extensions = [
          "js"
          "mjs"
          "cjs"
          "ts"
          "mts"
          "cts"
          "jsx"
          "tsx"
        ];
        detect_files = [
          "package.json"
          ".node-version"
          ".nvmrc"
          "pnpm-lock.yaml"
          "yarn.lock"
        ];
      };

      custom = {
        jj = {
          shell = starshipFishShell;
          when = "jj root --ignore-working-copy >/dev/null 2>&1";
          format = "$output";
          unsafe_no_escape = true;
          command = ''
            ${colorizeShortId}

            set -l metadata (
              command jj log \
                -r @ \
                --ignore-working-copy \
                --no-pager \
                --no-graph \
                -T 'if(bookmarks, bookmarks, "-") ++ "\t" ++ change_id.shortest(8).prefix() ++ "\t" ++ change_id.shortest(8).rest() ++ "\t" ++ if(empty, "1", "0") ++ "\t" ++ if(conflict, "1", "0") ++ "\t" ++ if(description.first_line(), description.first_line(), "-")' \
                2>/dev/null | string trim
            )

            test -n "$metadata"; or exit 1

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

            __starship_colorize_short_id $short_id_prefix "$short_id_rest"

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

        git = {
          shell = starshipFishShell;
          when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1";
          format = "$output";
          unsafe_no_escape = true;
          command = ''
            command jj root --ignore-working-copy >/dev/null 2>&1; and exit 1

            ${colorizeShortId}

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
              __starship_colorize_short_id $ref
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
      };
    };
  };

  programs.fish.interactiveShellInit = ''
    function starship_transient_prompt_func
      set_color --bold brcyan
      printf '> '
      set_color normal
    end
  '';
}
