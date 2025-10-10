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
        soft-wrap={
          enable=true;
        };
      };
      keys.normal = {
        space.space = ":w";
        space.q = ":q";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        d ="delete_selection_noyank";
        "A-d"="delete_selection";
        c= "change_selection_noyank";
        "A-c"="change_selection";
        "="=":fmt";
      };
      keys.insert = {
        j = {
          k = "normal_mode";
        };
        g ={
          a="code_action";
        };
      };
    };
    languages = {
      language = [
        {
          name = "racket";
          scope = "source.racket";
          file-types = [ "rkt" "scrbl" "rktl" ];
          comment-token = ";";
          formatter = {
            command = "raco";
            args = [ "fmt" "%{buffer_name}" ];
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
