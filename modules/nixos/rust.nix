# modules/nixos/rust.nix
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # 从 flake.nix 的 inputs 中引入 rust-overlay
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  environment.systemPackages = [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "rust-src"
      ];
    })
    pkgs.cargo
    pkgs.rust-analyzer
  ];
}
