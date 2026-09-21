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
  inputs,
  ...
}: {
  options.modules.home.enable = lib.mkEnableOption "Home Manager";

  config = lib.mkIf config.modules.home.enable {
    # Use the system nixpkgs instead of letting home-manager build its own.
    home-manager.useGlobalPkgs = true;

    # Inject the flake inputs plus the feature flags into every home module.
    # `features` bridges the NixOS modules.*.enable booleans (and the GPU gate)
    # so the same home modules also work outside NixOS (home/standalone.nix).
    home-manager.extraSpecialArgs = {
      inherit inputs;
      features = {
        desktop = config.modules.desktop.enable;
        gaming = config.modules.gaming.enable;
        graphics = config.myConfig.gpu.provider != null;
      };
    };

    home-manager.users.${config.myConfig.username} = {
      # Keep home files compatible with this NixOS release.
      home.stateVersion = "26.05";

      # Themed package modules and per-program configurations.
      imports = [
        ./shell.nix
        ./cli.nix
        ./dev.nix
        ./graphics.nix
        ./desktop.nix
        ./gaming.nix
        ./programs
      ];
    };
  };
}
