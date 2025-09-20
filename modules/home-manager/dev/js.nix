{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    deno
    yarn
  ];

}
