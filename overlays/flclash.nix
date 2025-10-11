# overlays/flclash-fix.nix
self: super:
let
  inherit (super) lib;
in
# 仅当 nixpkgs 有 flclash 这个 attribute 时才 override
if super ? flclash then {
  flclash = super.flclash.overrideAttrs (old: {
    buildPhase = ''
      # 先运行 pub get（通常会生成 linux/flutter/ephemeral/... 的 symlink）
      flutter pub get || true

      # 找到生成的 plugin 源文件并初始化造成错误的变量
      for f in $(find . -type f -path '*/.plugin_symlinks/hotkey_manager_linux/*hotkey_manager_linux_plugin.cc'); do
        [ -f "$f" ] || continue
        substituteInPlace "$f" \
          --replace 'const char* identifier;' 'const char* identifier = "";' \
          --replace 'const char* keystring;' 'const char* keystring = "";' || true
      done

      # 然后继续原来的 buildPhase
      ${old.buildPhase}
    '';
  });
} else { }

