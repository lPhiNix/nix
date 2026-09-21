#  _   _ _        _   _
# | \ | (_)_  __ | | | | ___  _ __ ___   ___
# |  \| | \ \/ / | |_| |/ _ \| '_ ` _ \ / _ \
# | |\  | |>  <  |  _  | (_) | | | | | |  __/
# |_| \_|_/_/\_\ |_| |_|\___/|_| |_| |_|\___|
# -------------------------------------------
# Standalone home layer by lPhiNix
#
# Entry point to reuse the SAME home modules outside NixOS, via Home Manager
# standalone on any Linux with Nix:
#
#   home-manager switch --flake ~/.nix#standalone
#
# The same modules as the NixOS integration. Their desktop/gaming/graphics
# packages are gated through the `features` specialArg (injected from
# flake.nix), so they work without NixOS and without defining a host.
{...}: {
  imports = [
    ./shell.nix
    ./cli.nix
    ./dev.nix
    ./graphics.nix
    ./desktop.nix
    ./gaming.nix
    ./programs
  ];

  # Keep home files compatible with this release.
  home.stateVersion = "26.05";

  # Required by Home Manager outside NixOS (session vars/paths for GUI apps).
  targets.genericLinux.enable = true;
}
