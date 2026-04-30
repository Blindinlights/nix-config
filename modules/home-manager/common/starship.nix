{ pkgs, ... }:

let
  starshipNushellShell = [
    "${pkgs.nushell}/bin/nu"
    "--no-config-file"
    "--commands"
  ];

  colorizeShortId = ''
    def __starship_colorize_short_id [first_half: string, second_half?: string] {
      mut first = $first_half
      mut second = ($second_half | default "")

      if $second_half == null {
        let short_id = ($first_half | str substring 0..<8)
        $first = ($short_id | str substring 0..<4)
        $second = ($short_id | str substring 4..<8)
      }

      print --no-newline (ansi light_red)
      print --no-newline $first

      if ($second | is-not-empty) {
        print --no-newline (ansi light_yellow)
        print --no-newline $second
      }

      print --no-newline (ansi reset)
    }
  '';
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
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
      right_format = "$nix_shell$ocaml$typst$python$rust$nodejs";

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

      nix_shell = {
        format = "[$symbol:$state(:$name)]($style) ";
        style = "bold blue";
        symbol = "󱄅";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "unknown";
      };

      ocaml = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold magenta";
        symbol = "";
        detect_extensions = [
          "ml"
          "mli"
          "re"
          "rei"
        ];
        detect_files = [
          "dune"
          "dune-project"
          "jbuild"
          ".merlin"
        ];
      };

      typst = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold cyan";
        symbol = "";
        detect_extensions = [ "typ" ];
        detect_files = [
          "typst.toml"
          "Typst.toml"
        ];
      };

      python = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold yellow";
        symbol = " ";
      };

      rust = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold red";
        symbol = "";
      };

      nodejs = {
        format = "[$symbol(:$version)]($style) ";
        style = "bold green";
        symbol = "";
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
          shell = starshipNushellShell;
          when = "jj root --ignore-working-copy out> /dev/null err> /dev/null";
          format = "$output";
          unsafe_no_escape = true;
          command = ''
            ${colorizeShortId}

            let metadata = (
              jj log
                -r @
                --ignore-working-copy
                --no-pager
                --no-graph
                -T 'if(bookmarks, bookmarks, "-") ++ "\t" ++ change_id.shortest(8).prefix() ++ "\t" ++ change_id.shortest(8).rest() ++ "\t" ++ if(empty, "1", "0") ++ "\t" ++ if(conflict, "1", "0") ++ "\t" ++ if(description.first_line(), description.first_line(), "-")'
                err> /dev/null
              | str trim
            )

            if ($metadata | is-empty) {
              exit 1
            }

            let fields = ($metadata | split row "\t")
            let bookmarks = ($fields | get 0)
            let short_id_prefix = ($fields | get 1)
            let short_id_rest = ($fields | get 2)
            let is_empty = ($fields | get 3)
            let has_conflict = ($fields | get 4)
            let summary = ($fields | get 5)

            print --no-newline (ansi light_magenta_bold)
            print --no-newline " jj"

            print --no-newline (ansi dark_gray)
            print --no-newline ":"

            if $bookmarks != "-" {
              print --no-newline (ansi light_green_bold)
              print --no-newline $bookmarks

              print --no-newline (ansi white)
              print --no-newline "@"
            }

            __starship_colorize_short_id $short_id_prefix $short_id_rest

            if $is_empty == "1" {
              print --no-newline (ansi yellow)
              print --no-newline " empty"
            }

            if $has_conflict == "1" {
              print --no-newline (ansi light_red)
              print --no-newline " conflict"
            }

            print --no-newline (ansi dark_gray)
            if $summary != "-" {
              print --no-newline " "
              print --no-newline ($summary | str substring 0..<28)
            } else {
              print --no-newline " no-desc"
            }

            print --no-newline (ansi reset)
          '';
        };

        git = {
          shell = starshipNushellShell;
          when = "git rev-parse --is-inside-work-tree out> /dev/null err> /dev/null";
          format = "$output";
          unsafe_no_escape = true;
          command = ''
            let jj_root = (jj root --ignore-working-copy | complete)
            if $jj_root.exit_code == 0 {
              exit 1
            }

            ${colorizeShortId}

            let ref_result = (git symbolic-ref --quiet --short HEAD | complete)
            mut ref = ($ref_result.stdout | str trim)
            mut detached = false

            if ($ref | is-empty) {
              $detached = true
              $ref = (git rev-parse --short HEAD err> /dev/null | str trim)
            }

            mut staged = 0
            mut unstaged = 0
            mut untracked = 0

            for line in (git status --porcelain --ignore-submodules=dirty err> /dev/null | lines) {
              let index_state = ($line | str substring 0..<1)
              let worktree_state = ($line | str substring 1..<2)

              if $index_state == "?" {
                $untracked = ($untracked + 1)
                continue
              }

              if $index_state != " " {
                $staged = ($staged + 1)
              }

              if $worktree_state != " " {
                $unstaged = ($unstaged + 1)
              }
            }

            print --no-newline (ansi light_blue_bold)
            print --no-newline " git"

            print --no-newline (ansi dark_gray)
            print --no-newline ":"

            if $detached {
              __starship_colorize_short_id $ref
            } else {
              print --no-newline (ansi green_bold)
              print --no-newline $ref
            }

            if $staged > 0 {
              print --no-newline (ansi light_green)
              print --no-newline $" +($staged)"
            }

            if $unstaged > 0 {
              print --no-newline (ansi yellow)
              print --no-newline $" ~($unstaged)"
            }

            if $untracked > 0 {
              print --no-newline (ansi light_red)
              print --no-newline $" ?($untracked)"
            }

            print --no-newline (ansi reset)
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
