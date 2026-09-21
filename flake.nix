#     ____  __    _ _   ___
#    / __ \/ /_  (_) | / (_)  __
#   / /_/ / __ \/ /  |/ / / |/_/
#  / ____/ / / / / /|  / />  <
# /_/   /_/ /_/_/_/ |_/_/_/|_|
# ------------------------------
# Nix configuration by lPhiNix
#
{
  description = "PhiNix Configuration";

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

    # Declarative disk partitioning, pinned to the same nixpkgs.
    disko = {
      url = "github:nix-community/disko";
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
    # Architecture for flake-level outputs (formatter, packages). Hosts are
    # NOT tied to this: each one declares nixpkgs.hostPlatform in its own
    # hardware.nix, so an aarch64 machine needs no change here.
    defaultSystem = "x86_64-linux";

    # --- Host discovery ---
    # Every subdirectory of hosts/ that contains a default.nix is a machine.
    hostEntries = builtins.readDir ./hosts;
    isHost = name:
      hostEntries.${name}
      == "directory"
      && builtins.pathExists ./hosts/${name}/default.nix;
    hostNames = builtins.filter isHost (builtins.attrNames hostEntries);

    # Build a host: its own directory plus the shared system modules.
    # No explicit `system` argument: it is derived from the host's own
    # nixpkgs.hostPlatform, which keeps the flake multi-architecture.
    mkHost = name:
      nixpkgs.lib.nixosSystem {
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
    formatter.${defaultSystem} = nixpkgs.legacyPackages.${defaultSystem}.alejandra;

    # Custom packages from ./pkgs, runnable via `nix run .#name`.
    packages.${defaultSystem} = import ./pkgs nixpkgs.legacyPackages.${defaultSystem};

    # Overlays consumed by modules/core.nix.
    overlays = import ./overlays {inherit inputs;};

    # Real machines, discovered automatically from hosts/.
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;

    # Same home modules, usable OUTSIDE NixOS (Home Manager standalone).
    # Single, host-agnostic entry valid on any Linux with Nix:
    #   home-manager switch --flake ~/.nix#standalone
    # Feature flags are plain preferences (no host data), so no machine
    # needs to be defined.
    homeConfigurations.standalone = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = defaultSystem;
        config.allowUnfree = true;
        overlays = [
          self.overlays.additions
          self.overlays.modifications
          self.overlays.unstable-packages
        ];
      };
      extraSpecialArgs = {
        inherit inputs;
        features = {
          desktop = true;
          gaming = false;
          graphics = true;
        };
      };
      modules = [
        ./home/standalone.nix
        {
          home.username = "phinix";
          home.homeDirectory = "/home/phinix";
        }
      ];
    };
  };
}
