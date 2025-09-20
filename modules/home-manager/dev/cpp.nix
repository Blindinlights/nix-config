{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    cmake
    llvm
    lldb
    lld
    mold
    valgrind
  ];

}
