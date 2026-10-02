#  _   _ _        _   _
# | \ | (_)_  __ | | | | ___  _ __ ___   ___
# |  \| | \ \/ / | |_| |/ _ \| '_ ` _ \ / _ \
# | |\  | |>  <  |  _  | (_) | | | | | |  __/
# |_| \_|_/_/\_\ |_| |_|\___/|_| |_| |_|\___|
# -------------------------------------------
# Shared home layer by lPhiNix
#
# Single source of the home module list and the release version. Imported by
# both the NixOS integration (home/default.nix) and the standalone entry
# point (home/standalone.nix), so they can never drift apart.
{inputs, ...}: {
  imports = [
    # Dotfiles (the lPhiNix/dotfiles flake) provide their own Home Manager module.
    inputs.dotfiles.homeManagerModules.default

    ./options.nix
    ./shell.nix
    ./cli.nix
    ./dev.nix
    ./graphics.nix
    ./desktop.nix
    ./gaming.nix
    ./programs
  ];

  # Deploy the dotfiles into the home directory.
  dotfiles.enable = true;

  # Keep home files compatible with this release.
  home.stateVersion = "26.05";
}
