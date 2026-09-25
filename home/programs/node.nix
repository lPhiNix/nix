#    _  ___        _  __        __
#   / |/ (_)_ __  / |/ /__  ___/ /__
#  /    / /\ \ / /    / _ \/ _  / -_)
# /_/|_/_//_\_\ /_/|_/\___/\_,_/\__/
# -----------------------------------
# Node nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs-slim_24 # Node.js runtime without npm/corepack
    pnpm_11 # Fast, disk space efficient package manager

    typescript # tsc compiler and TypeScript language service
    typescript-language-server # TypeScript language server (LSP)
    biome # TS linter and formatter (replaces eslint/prettier)
    tsx # Run TypeScript directly, with full syntax
  ];
}
