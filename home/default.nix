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

    # Inject the flake inputs and the NixOS config into every home module.
    # nixosConfig lets each module gate packages on the host's modules.*.enable.
    home-manager.extraSpecialArgs = {
      inherit inputs;
      nixosConfig = config;
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
