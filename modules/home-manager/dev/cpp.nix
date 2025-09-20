{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    clang
    cmake
    gdb
    llvm
    lldb
    lld
    mold
    valgrind
  ];

}
