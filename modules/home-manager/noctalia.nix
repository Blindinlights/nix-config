{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];
  home.sessionVariables = {
    QS_ICON_THEME = "Papirus";
  };
  programs.noctalia-shell =
    # let
    #   default-wallpaper = ./images/wallpapers/winxp.jpeg;
    #   avatar-image = ./images/avatar.jpg;
    #   wallpaper-dir = ./images/wallpapers;
    # in

    {
      enable = true;

      # settings = {
      #   general = {
      #     avatarImage = avatar-image;
      #     language = "zh-CN";

      #   };

      #   bar = {
      #     backgroundOpacity = 0;
      #     density = "default";
      #     floating = false;
      #     marginHorizontal = 0.25;
      #     marginVertical = 0.25;
      #     monitors = [ ];
      #     position = "top";
      #     showCapsule = true;
      #     widgets = {
      #       center = [ { "id" = "Clock"; } ];
      #       left = [
      #         { id = "Workspace"; }
      #         { id = "ActiveWindow"; }
      #         { id = "MediaMini"; }
      #       ];
      #       right = [
      #         {
      #           id = "Tray";
      #         }
      #         { id = "Bluetooth"; }
      #         { id = "WiFi"; }
      #         { id = "NotificationHistory"; }
      #         { id = "Battery"; }
      #         { id = "Volume"; }
      #         { id = "Brightness"; }
      #         { id = "DarkMode"; }
      #         { id = "ControlCenter"; }
      #       ];
      #     };
      #   };
      #   location = {
      #     name = "Xi'an";
      #     showWeekNumberInCalendar = true;
      #     use12hourFormat = false;
      #     useFahrenheit = false;
      #     weatherEnabled = true;
      #   };
      #   wallpaper = {
      #     defaultWallpaper = default-wallpaper;
      #     directory = wallpaper-dir;
      #   };
      #   appLauncher = {
      #     enableClipboardHistory = true;
      #     position = "center";
      #     backgroundOpacity = 0.85;
      #     pinnedExecs = [ ];
      #     useApp2Unit = false;
      #     sortByMostUsed = true;
      #     terminalCommand = "xterm -e";
      #   };

      #   colorSchemes = {
      #     darkMode = false;
      #     useWallpaperColors = true;
      #   };
      #   dock = {
      #     enable = false;
      #   };
      #   hooks = {
      #     enabled = true;
      #     darkModeChange = "darkman toggle";
      #   };
      # };
    };
}
