#    _  ___        __ __     __  ___
#   / |/ (_)_ __  / //_/__  / /_/ (_)__
#  /    / /\ \ / / ,< / _ \/ __/ / / _ \
# /_/|_/_//_\_\ /_/|_|\___/\__/_/_/_//_/
# --------------------------------------
# Kotlin nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.unstablePkgs.kotlin # Kotlin compiler (kotlinc) and REPL
    kotlin-language-server # Kotlin language server (LSP)
    ktlint # Kotlin linter and formatter
    pkgs.unstablePkgs.ktfmt # Kotlin formatter (Google style)

    gradle_8 # JVM build tool
  ];
}
