#    _  ___        __
#   / |/ (_)_ __  / /  __ _____ _
#  /    / /\ \ / / /__/ // / _ `/
# /_/|_/_//_\_\ /____/\_,_/\_,_/
# --------------------------------
# Lua nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    lua5_4 # Lua 5.4 interpreter and luac compiler
    pkgs.unstablePkgs.lua-language-server # Lua language server (LSP)
    stylua # Lua formatter
  ];
}
