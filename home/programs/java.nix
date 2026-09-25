#    _  ___           __
#   / |/ (_)_ __  __ / /__ __  _____ _
#  /    / /\ \ / / // / _ `/ |/ / _ `/
# /_/|_/_//_\_\  \___/\_,_/|___/\_,_/
# --------------------------------------------
# Java nix home packages and config by lPhiNix
#
{pkgs, ...}: {
  home.packages = [
    pkgs.jdk17 # Default JDK installed on PATH.
    pkgs.jdt-language-server # Java language server.

    # Maven JVM build tool, pinned to the same JDK 17.
    (pkgs.maven.override {jdk_headless = pkgs.jdk17_headless;})

    # Spring Boot CLI (spring init), pinned to the same JDK 17.
    (pkgs."spring-boot-cli".override {jdk = pkgs.jdk17;})

    # Wrappers to run a specific Java version: java8, java17, java21.
    (pkgs.writeShellScriptBin "java8" "exec ${pkgs.jdk8}/bin/java \"$@\"")
    (pkgs.writeShellScriptBin "java17" "exec ${pkgs.jdk17}/bin/java \"$@\"")
    (pkgs.writeShellScriptBin "java21" "exec ${pkgs.jdk21}/bin/java \"$@\"")
  ];
}
