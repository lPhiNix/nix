#  _   _ _        _   _
# | \ | (_)_  __ | | | | ___  _ __ ___   ___
# |  \| | \ \/ / | |_| |/ _ \| '_ ` _ \ / _ \
# | |\  | |>  <  |  _  | (_) | | | | | |  __/
# |_| \_|_/_/\_\ |_| |_|\___/|_| |_| |_|\___|
# -------------------------------------------
# Nix Home Manager configuration by lPhiNix
#
{
  config,
  lib,
  inputs,
  ...
}: {
  options.modules.home.enable = lib.mkEnableOption "Home Manager";

  config = lib.mkIf config.modules.home.enable {
    # Use the system nixpkgs instead of letting Home Manager build its own.
    home-manager.useGlobalPkgs = true;

    # Expose the flake inputs to the home modules (e.g. the dotfiles source).
    home-manager.extraSpecialArgs = {inherit inputs;};

    home-manager.users.${config.myConfig.username} = {
      # Shared module list + release version (home/shared.nix).
      imports = [./shared.nix];
    };
  };
}
