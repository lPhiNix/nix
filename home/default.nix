#  _   _ _        _   _
# | \ | (_)_  __ | | | | ___  _ __ ___   ___
# |  \| | \ \/ / | |_| |/ _ \| '_ ` _ \ / _ \
# | |\  | |>  <  |  _  | (_) | | | | | |  __/
# |_| \_|_/_/\_\ |_| |_|\___/|_| |_| |_|\___|
# -------------------------------------------
# Nix home manager configuration by lPhiNix
#
{
  config,
  lib,
  ...
}: {
  options.modules.home.enable = lib.mkEnableOption "Home Manager";

  config = lib.mkIf config.modules.home.enable {
    # Use the system nixpkgs instead of letting home-manager build its own.
    home-manager.useGlobalPkgs = true;

    home-manager.users.${config.myConfig.username} = {
      # Shared module list + release version (home/shared.nix).
      imports = [./shared.nix];

      # Typed toggles (see home/options.nix), bridged from the NixOS
      # modules.*.enable booleans so the same modules also work outside NixOS.
      features = {
        desktop = config.modules.desktop.enable;
        gaming = config.modules.gaming.enable;
        graphics = config.modules.graphics.enable;
      };
    };
  };
}
