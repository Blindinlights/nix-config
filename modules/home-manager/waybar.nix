# In your home.nix or a dedicated waybar.nix file
{ pkgs, ... }:

{
  # 启用 Waybar
  programs.waybar = {
    enable = true;

    # 将 JSON 配置转换为 Nix attribute set
    # 'mainbar' 是您状态栏的任意名称，可以修改
    settings = {
      mainbar = {
        # --- Bar Settings ---
        layer = "top";
        position = "top";
        height = 38;
        spacing = 4;

        # --- Module Placement ---
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "disk"
          "tray"
          "custom/power"
        ];

        # --- Module Configurations ---

        "niri/workspaces" = {
          format = "{icon}";
          "format-icons" = {
            "1" = "  Home";
            "2" = "  Code";
            "3" = "  Term";
            "default" = "";
          };
        };

        tray = {
          "icon-size" = 18;
          spacing = 10;
        };

        clock = {
          format = "  {:%H:%M}";
          "format-alt" = "  {:%Y-%m-%d}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "  {usage}%";
          tooltip = true;
          "on-click" = "foot --title btop btop";
        };

        memory = {
          # 建议使用这个图标 `󰍛`，它更符合内存的意象
          # format = "󰍛 {}%";
          format = "  {}%";
          "on-click" = "foot --title btop btop";
        };

        disk = {
          format = "  {percentage_used}%";
          path = "/";
          tooltip = true;
          "tooltip-format" = "Total: {total} | Free: {free}";
          "on-click" = "foot --title btop btop";
        };

        network = {
          "format-wifi" = "  {essid}";
          "format-ethernet" = "󰈀  {ifname}";
          "format-disconnected" = "󰖪  Disconnected";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "on-click" = "foot -e nmtui";
        };

        wireplumber = {
          format = "{icon}  {volume}%";
          "format-muted" = "󰝟  Muted";
          "on-click" = "pavucontrol";
          "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "format-icons" = {
            headphone = "";
            "hands-free" = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          "on-click" = "wlogout";
        };
      };
    };
    style = ''
      /* ---- Global Styles ---- */
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(
              26,
              27,
              38,
              0.8
          ); /* Dark background with some transparency */
          color: #cdd6f4; /* Catppuccin Macchiato Text color */
          transition-property: background-color;
          transition-duration: 0.5s;
      }

      /* ---- Module Styles ---- */
      .modules-left,
      .modules-center,
      .modules-right {
          padding: 0 5px;
      }

      #workspaces,
      #clock,
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #disk,
      #tray,
      #custom-launcher,
      #custom-power {
          padding: 5px 12px;
          margin: 4px 2px;
          background-color: #1e1e2e; /* Catppuccin Macchiato Base */
          border-radius: 8px; /* Rounded corners for modules */
      }

      /* ---- Specific Module States ---- */

      /* Workspaces */
      #workspaces button {
          color: #494d64; /* Inactive workspace color */
          padding: 2px 5px;
          border-radius: 6px;
          transition: all 0.3s ease;
      }

      #workspaces button:hover {
          background-color: #313244; /* Slightly lighter background on hover */
          color: #cdd6f4;
      }

      #workspaces button.active {
          color: #89b4fa; /* Blue for active workspace */
          background-color: #45475a;
      }

      #workspaces button.urgent {
          background-color: #f38ba8; /* Red for urgent workspace */
          color: #11111b;
      }

      /* Launcher & Power */
      #custom-launcher {
          color: #89b4fa; /* Blue */
          background-color: #313244;
      }

      #custom-power {
          color: #f38ba8; /* Red */
          background-color: #313244;
      }

      /* Clock */
      #clock {
          color: #a6e3a1; /* Green */
      }

      /* System Tray */
      #tray {
          background-color: #313244;
      }

      /* Hardware & Network Modules */
      #pulseaudio {
          color: #f9e2af; /* Yellow */
      }
      #pulseaudio.muted {
          color: #494d64; /* Muted color */
      }

      #network {
          color: #89b4fa; /* Blue */
      }
      #network.disconnected {
          color: #f38ba8; /* Red */
      }

      #cpu {
          color: #fab387; /* Peach */
      }

      #memory {
          color: #cba6f7; /* Mauve */
      }

      #disk {
          color: #74c7ec; /* Sky */
      }

      /* Tooltip style */
      tooltip {
          background-color: #1e1e2e;
          border: 1px solid #313244;
          border-radius: 8px;
          padding: 8px;
      }

      tooltip label {
          color: #cdd6f4;
      }

    '';
  };
}
