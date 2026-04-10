{ pkgs, inputs, ... }:

let
  helixSteel =
    inputs.helix-steel.packages.${pkgs.stdenv.hostPlatform.system}.helix.overrideAttrs
      (_old: {
        cargoBuildFeatures = [
          "steel"
          "git"
        ];
      });
  infoKeybindings = {
    p = ":copy-current-path";
    P = ":copy-current-position";
  };
  markdownKeybindings = {
    l = ":markdown-link-selection";
  };
  openKeybindings = {
    h = ":open-helix-scm";
    i = ":open-init-scm";
  };
  testKeybindings = {
    r = ":cargo-test-nearest";
  };
  textKeybindings = {
    c = ":selection-smart-case";
    u = ":selection-upcase";
    l = ":selection-downcase";
    b = ":selection-toggle-bool";
    s = ":trim-and-copy-selection";
  };
in
{
  home.file = {
    ".config/helix/init.scm" = {
      source = ../dotfiles/helix/init.scm;
    };
    ".config/helix/helix.scm" = {
      source = ../dotfiles/helix/helix.scm;
    };
  };

  programs.helix = {
    enable = true;
    package = helixSteel;
    defaultEditor = true;
    extraPackages = [
      pkgs.steel
      pkgs.kdlfmt
      pkgs.lua-language-server

    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        bufferline = "always";
        line-number = "relative";
        lsp.display-messages = true;
        lsp = {
          display-inlay-hints = true;
        };
        soft-wrap = {
          enable = true;
        };
      };
      keys.normal = {
        "tab" = {
          "tab" = ":w";
          "=" = [
            ":format"
            ":w"
          ];
          "q" = ":wq";
        };
        # "[j"="jump_backward";
        # "]j"="jump_forward";
        "`" = ":selection-smart-case";
        "~" = ":selection-toggle-bool";
        space.e = "file_explorer_in_current_buffer_directory";
        space.E = "file_explorer";
        space.i = infoKeybindings;
        space.m = markdownKeybindings;
        space.o = openKeybindings;
        space.t = testKeybindings;
        space.T = textKeybindings;
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        "C-d" = ":half-page-down-smooth";
        "C-u" = ":half-page-up-smooth";
        pageup = ":page-up-smooth";
        pagedown = ":page-down-smooth";
        d = "delete_selection_noyank";
        "A-d" = "delete_selection";
        c = "change_selection_noyank";
        "A-c" = "change_selection";
        "=" = ":fmt";
      };
      keys.select = {
        "`" = ":selection-smart-case";
        "~" = ":selection-toggle-bool";
        space.i = infoKeybindings;
        space.m = markdownKeybindings;
        space.o = openKeybindings;
        space.t = testKeybindings;
        space.T = textKeybindings;
      };
    };
    languages = {
      language = [
        {
          name = "racket";
          scope = "source.racket";
          file-types = [
            "rkt"
            "scrbl"
            "rktl"
          ];
          comment-token = ";";
          formatter = {
            command = "raco";
            args = [
              "fmt"
              "%{buffer_name}"
            ];
          };
        }
        {
          name = "scheme";
          language-servers = [ "steel-language-server" ];
        }
        {
          name = "c";
          auto-format = true;
        }
        {
          name = "cpp";
          auto-format = true;
        }

      ];
      language-server = {
        steel-language-server = {
          command = "steel-language-server";
        };
        clangd = {
          command = "clangd";
          args = [
            "--background-index"
            "--clang-tidy"
            "--log=verbose"
          ];
          config = {
            fallbackFlags = [ "-std=c++17" ];
          };
        };
      };
    };
    ignores = [
      "target/"
      "!.gitignore"
    ];
  };
}
