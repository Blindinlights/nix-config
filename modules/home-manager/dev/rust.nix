{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo-edit
    cargo-expand
  ];

}
