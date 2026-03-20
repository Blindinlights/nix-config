{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.kdlfmt
      pkgs.nodePackages.vscode-json-languageserver
      pkgs.lua-language-server

    ];
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        bufferline = "always";
        line-number = "relative";
        lsp.display-messages = true;
        # inline-diagnostics = {
        #   cursor-line = "hint";
        #   other-lines = "error";
        # };
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
        "[j"="jump_backward";
        "]j"="jump_forward";
        space.e = "file_explorer_in_current_buffer_directory";
        space.E = "file_explorer";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        d = "delete_selection_noyank";
        "A-d" = "delete_selection";
        c = "change_selection_noyank";
        "A-c" = "change_selection";
        "=" = ":fmt";
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
