#    _  ___        __________
#   / |/ (_)_ __  / ___/ ___/
#  /    / /\ \ / / /__/ /__
# /_/|_/_//_\_\  \___/\___/
# -------------------------------------------
# CC (C and C++) nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc # C/C++ compiler (also provides cc/c++)
    pkgs.unstablePkgs.cmake # Cross-platform C/C++ build system
    ninja # Fast, minimal build system
    gnumake # Make build tool
    pkg-config # Helper for compiler/linker flags
    gdb # C/C++ debugger
    clang-tools # clangd: C/C++ language server
    pkgs.unstablePkgs.neocmakelsp # CMake language server
  ];
}
