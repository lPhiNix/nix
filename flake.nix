#     ________      __                _
#    / ____/ /___ _/ /_____    ____  (_)  __
#   / /_  / / __ `/ //_/ _ \  / __ \/ / |/_/
#  / __/ / / /_/ / ,< /  __/ / / / / />  <
# /_/   /_/\__,_/_/|_|\___(_)_/ /_/_/_/|_|
# ------------------------------------------
# Nix flake configuration by lPhiNix
#
{
  # Flake name, shown in `nix flake metadata`.
  description = "PhiNix Nix Configuration";

  inputs = {
    # Stable nixpkgs channel: basis of the system.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Unstable nixpkgs, exposed to packages via an overlay.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-manager, pinned to the same nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop control CLI (dotfiles tool) from an external flake.
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Architecture targeted by this configuration.
    system = "x86_64-linux";

    # --- Host discovery ---
    # Every subdirectory of hosts/ that contains a default.nix is a machine.
    hostEntries = builtins.readDir ./hosts;
    isHost = name:
      hostEntries.${name}
      == "directory"
      && builtins.pathExists ./hosts/${name}/default.nix;
    hostNames = builtins.filter isHost (builtins.attrNames hostEntries);

    # Build a host: its own directory plus the shared system modules.
    mkHost = name:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          # Host-specific configuration (hosts/<name>/default.nix).
          ./hosts/${name}

          # Shared system modules + myConfig translation.
          ./modules

          # Home-manager integration and the home configuration.
          home-manager.nixosModules.home-manager
          ./home
        ];
      };
  in {
    # Formatter used by `nix fmt` (Alejandra).
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    # Custom packages from ./pkgs, runnable via `nix run .#name`.
    packages.${system} = import ./pkgs nixpkgs.legacyPackages.${system};

    # Overlays consumed by modules/core.nix.
    overlays = import ./overlays {inherit inputs;};

    # Real machines, discovered automatically from hosts/.
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;
  };
}
