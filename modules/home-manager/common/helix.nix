{ ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        bufferline = "always";
        line-number = "relative";
        lsp.display-messages = true;
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        lsp = {
          display-inlay-hints = true;
        };
      };
      keys.normal = {
        space.space = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
      keys.insert = {
        j = {
          k = "normal_mode";
        };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };
    ignores = [
      "target/"
      "!.gitignore"
    ];
  };
}
