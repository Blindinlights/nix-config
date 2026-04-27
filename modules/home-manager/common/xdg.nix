{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;

  xdgDirs = [
    "${cacheHome}/X11"
    "${cacheHome}/bun/install/cache"
    "${cacheHome}/buildroot-ccache"
    "${cacheHome}/ccache"
    "${cacheHome}/deno"
    "${cacheHome}/npm"
    "${cacheHome}/nv"
    "${cacheHome}/triton"
    "${configHome}/gtk-2.0"
    "${configHome}/npm"
    "${configHome}/npm/config"
    "${dataHome}/bun/bin"
    "${dataHome}/cargo/bin"
    "${dataHome}/deno/bin"
    "${dataHome}/dotnet/tools"
    "${dataHome}/elan/bin"
    "${dataHome}/npm/bin"
    "${stateHome}/bash"
    "${stateHome}/less"
    "${stateHome}/node"
    "${stateHome}/python"
    "${stateHome}/sqlite"
  ];
in
{
  xdg.enable = true;

  home.packages = with pkgs; [
    xdg-ninja
  ];

  home.sessionPath = [
    "${dataHome}/bun/bin"
    "${dataHome}/cargo/bin"
    "${dataHome}/deno/bin"
    "${dataHome}/dotnet/tools"
    "${dataHome}/elan/bin"
    "${dataHome}/npm/bin"
  ];

  home.sessionVariables = {
    XDG_CACHE_HOME = cacheHome;
    XDG_CONFIG_HOME = configHome;
    XDG_DATA_HOME = dataHome;
    XDG_STATE_HOME = stateHome;

    BR2_CCACHE_DIR = "${cacheHome}/buildroot-ccache";
    BUN_INSTALL = "${dataHome}/bun";
    BUN_INSTALL_CACHE_DIR = "${cacheHome}/bun/install/cache";

    CARGO_HOME = "${dataHome}/cargo";
    CCACHE_DIR = "${cacheHome}/ccache";
    CUDA_CACHE_PATH = "${cacheHome}/nv";
    RUSTUP_HOME = "${dataHome}/rustup";

    DENO_DIR = "${cacheHome}/deno";
    DENO_INSTALL_ROOT = "${dataHome}/deno";

    DOTNET_CLI_HOME = "${dataHome}/dotnet";
    ELAN_HOME = "${dataHome}/elan";
    GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
    HISTFILE = "${stateHome}/bash/history";
    NUGET_PACKAGES = "${cacheHome}/NuGetPackages";

    LESSHISTFILE = "${stateHome}/less/history";
    NODE_REPL_HISTORY = "${stateHome}/node/repl_history";

    NPM_CONFIG_CACHE = "${cacheHome}/npm";
    NPM_CONFIG_INIT_MODULE = "${configHome}/npm/config/npm-init.js";
    NPM_CONFIG_PREFIX = "${dataHome}/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";

    PYTHON_HISTORY = "${stateHome}/python/history";
    SQLITE_HISTORY = "${stateHome}/sqlite/history";
    TRITON_CACHE_DIR = "${cacheHome}/triton";
    TRITON_HOME = "${cacheHome}/triton";

    WGETRC = "${configHome}/wgetrc";
    XCOMPOSECACHE = "${cacheHome}/X11/xcompose";
    XCURSOR_PATH = "${dataHome}/icons:/run/current-system/sw/share/icons:/usr/share/icons";
    YARN_CACHE_FOLDER = "${cacheHome}/yarn";
  };

  xdg.configFile."npm/config/npm-init.js".text = "";
  xdg.configFile."npm/npmrc".text = ''
    prefix=${dataHome}/npm
  '';

  xdg.configFile."wgetrc".text = ''
    hsts-file = ${cacheHome}/wget-hsts
  '';

  home.activation.createXdgDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${lib.escapeShellArgs xdgDirs}
  '';
}
