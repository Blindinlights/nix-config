{ }:
let

  commonWaylandFlags = ''
    --ozone-platform-hint=auto
    --enable-features=WaylandWindowDecorations,WaylandWindowDecorations.cros,FractionalScale,WaylandFractionalScaling
    --enable-wayland-ime
  '';
in
{
  xdg.configFile = {
    # "electron-flags.conf".text = commonWaylandFlags;

    # "code-flags.conf".text = commonWaylandFlags;

    # "chromium-flags.conf".text = commonWaylandFlags;

    # "spotify-flags.conf".text = commonWaylandFlags;

    # "qq-flags.conf".text = commonWaylandFlags;
  };

}
