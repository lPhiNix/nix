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
    # Architectures for the flake-level outputs (formatter, packages,
    # standalone home configs). NixOS hosts are NOT tied to this: each one
    # declares nixpkgs.hostPlatform in its own hardware.nix.
    systems = ["x86_64-linux" "aarch64-linux"];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system: f system);

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
    # nixpkgs.hostPlatform, which keeps this multi-architecture.
    mkHost = name:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          # Host-specific configuration (hosts/<name>/default.nix).
          ./hosts/${name}

          # The directory name is the single source for the hostname: it is
          # also the nixosConfigurations attribute name.
          {networking.hostName = name;}

          # Shared system modules + myConfig translation.
          ./modules

          # Home-manager integration and the home configuration.
          home-manager.nixosModules.home-manager
          ./home
        ];
      };

    # --- Standalone Home Manager (outside NixOS) ---
    # Same home modules, one entry per architecture, valid on any Linux with
    # Nix (no host defined). Feature flags are plain preferences.
    featuresBySystem = {
      x86_64-linux = {
        desktop = true;
        gaming = false;
        graphics = true;
      };
      aarch64-linux = {
        desktop = false;
        gaming = false;
        graphics = true;
      };
    };

    mkStandalone = system: features:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.additions
            self.overlays.modifications
            self.overlays.unstable-packages
            self.overlays.caelestia-packages
          ];
        };
        modules = [
          ./home/standalone.nix
          {
            home.username = "phinix";
            home.homeDirectory = "/home/phinix";
            inherit features;
          }
        ];
      };
  in {
    # Formatter used by `nix fmt` (Alejandra), per system.
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages from ./pkgs, runnable via `nix run .#name`.
    packages = eachSystem (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Overlays consumed by modules/core.nix and the standalone pkgs.
    overlays = import ./overlays {inherit inputs;};

    # Real machines, discovered automatically from hosts/.
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;

    # Host-agnostic Home Manager configs, one per architecture:
    #   home-manager switch --flake ~/.nix#standalone-x86_64-linux
    homeConfigurations = nixpkgs.lib.listToAttrs (map (system: {
        name = "standalone-${system}";
        value = mkStandalone system featuresBySystem.${system};
      })
      systems);
  };
}
