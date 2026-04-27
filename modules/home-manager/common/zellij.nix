{ ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "glass-night";
      default_shell = "fish";
      default_layout = "compact";
      on_force_close = "quit";
      simplified_ui = true;
      show_startup_tips = false;
      # mouse_mode = false;
      scroll_buffer_size = 50000;
      pane_frames = false;
      copy_command = "wl-copy";
      ui = {
        pane_frames = {
          hide_session_name = true;
          hide_plugin_names = true;
        };
      };
      themes = {
        glass-night = {
          fg = [ 214 225 238 ];
          bg = [ 11 17 24 ];
          red = [ 244 114 116 ];
          green = [ 134 239 172 ];
          yellow = [ 250 204 21 ];
          blue = [ 125 174 255 ];
          magenta = [ 192 132 252 ];
          orange = [ 251 146 60 ];
          cyan = [ 125 211 252 ];
          black = [ 15 23 32 ];
          white = [ 232 240 248 ];
        };
      };
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
                  { "children" = { }; }
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:compact-bar";
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
