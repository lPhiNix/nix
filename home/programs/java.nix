#    _  ___           __
#   / |/ (_)_ __  __ / /__ __  _____ _
#  /    / /\ \ / / // / _ `/ |/ / _ `/
# /_/|_/_//_\_\  \___/\_,_/|___/\_,_/
# --------------------------------------------
# Java nix home packages and config by lPhiNix
#
{pkgs, ...}: {
  home.packages = [
    # Default JDK installed on PATH.
    pkgs.jdk17
    # Java language server.
    pkgs.jdt-language-server
    # Maven JVM build tool, pinned to the same JDK 17.
    (pkgs.maven.override {jdk_headless = pkgs.jdk17_headless;})
    # Wrappers to run a specific Java version: java8, java17, java21.
    (pkgs.writeShellScriptBin "java8" "exec ${pkgs.jdk8}/bin/java \"$@\"")
    (pkgs.writeShellScriptBin "java17" "exec ${pkgs.jdk17}/bin/java \"$@\"")
    (pkgs.writeShellScriptBin "java21" "exec ${pkgs.jdk21}/bin/java \"$@\"")
  ];
}
