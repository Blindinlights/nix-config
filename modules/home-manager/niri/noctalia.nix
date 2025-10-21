{ pkgs, inputs, ... }:
let

  configRoot = ../../..;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    inputs.noctalia.packages.${system}.default
  ];
  programs.noctalia-shell =
    let
      default-wallpaper = "${configRoot}/images/wallpapers/winxp.jpeg";
      avatar-image = "${configRoot}/images/avatar.jpg";
      wallpaper-dir = "${configRoot}/images/wallpapers";
    in

    {
      enable = true;

      settings = {
        general = {
          avatarImage = avatar-image;
          language = "zh-CN";

        };

        "bar" = {
          backgroundOpacity = 0;
          density = "default";
          floating = false;
          marginHorizontal = 0.25;
          marginVertical = 0.25;
          monitors = [ ];
          position = "top";
          showCapsule = true;
          widgets = {
            center = [ { "id" = "Clock"; } ];
            left = [
              { id = "Workspace"; }
              { id = "ActiveWindow"; }
              { id = "MediaMini"; }
            ];
            right = [
              { id = "Tray"; }
              { id = "Bluetooth"; }
              { id = "WiFi"; }
              { id = "NotificationHistory"; }
              { id = "Battery"; }
              { id = "Volume"; }
              { id = "Brightness"; }
              { id = "ControlCenter"; }
            ];
          };
        };
        location = {
          name = "Xi'an";
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
        };
        wallpaper = {
          defaultWallpaper = default-wallpaper;
          directory = wallpaper-dir;
        };
        hooks = {
          enable = true;
          darkmodeChange = "darkman toggle";
        };
      };
    };
}
