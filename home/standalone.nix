#  _   _ _        _   _
# | \ | (_)_  __ | | | | ___  _ __ ___   ___
# |  \| | \ \/ / | |_| |/ _ \| '_ ` _ \ / _ \
# | |\  | |>  <  |  _  | (_) | | | | | |  __/
# |_| \_|_/_/\_\ |_| |_|\___/|_| |_| |_|\___|
# -------------------------------------------
# Standalone Home Manager layer by lPhiNix
#
# The standalone config, for any Linux x86_64 with Nix:
#   home-manager switch --flake ~/.phix#standalone
{...}: {
  # Shared module list + release version (home/shared.nix).
  imports = [./shared.nix];

  # Required by Home Manager outside NixOS (session vars/paths for GUI apps).
  targets.genericLinux.enable = true;

  home.username = "phinix";
  home.homeDirectory = "/home/phinix";

  features = {
    desktop = true;
    gaming = false;
    graphics = true;
  };
}
