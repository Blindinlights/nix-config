
final: prev: {
  flclash = prev.appimageTools.wrapType2 {
    name = "flclash";
    src = prev.fetchurl {
      url = "https://github.com/chen08209/FlClash/releases/download/v0.8.90/FlClash-0.8.90-linux-amd64.AppImage";
      sha256 = "45fd70be034d33d55aeeaea1c2eb33bf4d6f444d54611165c7e194052c1d95";
    };

    extraPkgs =
      pkgs:
      (with pkgs; [
        webkitgtk
        libsecret
        gsettings-desktop-schemas
        gtk3
      ]);

  };
}
