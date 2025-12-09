{ ... }:
{
  programs.zellij = {
    enable = true;
    # enableFishIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      default_layout = "niri";
      simplified_ui = true;
      show_startup_tips = false;
      pane_frames = false;
      copy_command = "wl-copy";
    };
    layouts = {
      niri = {
        layout = {
          pane = { };
        };
      };
      dev = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                    };
                  }
                  { "children" = { }; }
                  {
                    pane = {
                      size = 2;
                      borderless = true;
                      plugin = {
                        location = "zellij:status-bar";
                      };
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Project";
                  focus = true;
                };
                _children = [
                  {
                    pane = {
                      command = "hx";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Git";
                };
                _children = [
                  {
                    pane = {
                      command = "lazygit";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Files";
                };
                _children = [
                  {
                    pane = {
                      command = "yazi";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Shell";
                };
                _children = [
                  {
                    pane = {
                      command = "fish";
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };
}
