#     ____  __    _
#    / __ \/ /_  (_)  __
#   / /_/ / __ \/ / |/_/
#  / ____/ / / / />  <
# /_/   /_/ /_/_/_/|_|
# ----------------------------
# Nix configuration by lPhiNix
#
{
  description = "Phix: Nix configuration by lPhiNix";

  inputs = {
    # Stable nixpkgs channel: basis of the system.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Unstable nixpkgs, exposed to packages via an overlay.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager, pinned to the same nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk partitioning, pinned to the same nixpkgs.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automated NixOS installer over SSH (kexec + disko).
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";

    # Caelestia desktop shell + CLI (also provides the Home Manager module).
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal dotfiles, consumed as a flake that provides a Home Manager
    # module (homeManagerModules.default) deploying every dotfile.
    dotfiles = {
      url = "github:lPhiNix/dotfiles";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Library helpers: nixpkgs with our overlays, and directory discovery.
    phixLib = import ./lib {inherit nixpkgs self;};

    # Architectures for the flake-level outputs (formatter, packages). NixOS
    # hosts and standalone configs are NOT tied to this: each one declares its
    # own platform.
    systems = ["x86_64-linux"];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system: f system);

    # --- Host discovery ---
    # Every subdirectory of hosts/ that contains a default.nix is a machine.
    hostNames = phixLib.discovered ./hosts;

    # Build a host: its own directory plus the shared system modules.
    # No explicit 'system' argument: it is derived from the host's own
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

          # Home Manager integration and the home configuration.
          home-manager.nixosModules.home-manager
          ./home
        ];
      };

    # --- Standalone Home Manager (outside NixOS) ---
    # A single config, for any Linux x86_64 with Nix (no host defined).
    standaloneConfig = home-manager.lib.homeManagerConfiguration {
      pkgs = phixLib.mkPkgs "x86_64-linux";
      extraSpecialArgs = {inherit inputs;};
      modules = [./home/standalone.nix];
    };
  in {
    # Formatter used by 'nix fmt' (Alejandra), per system.
    formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages from ./pkgs, runnable via 'nix run .#name'.
    packages = eachSystem (system:
      import ./pkgs nixpkgs.legacyPackages.${system}
      // {
        # Automated installer, runnable via 'nix run .#nixos-anywhere'.
        nixos-anywhere = inputs.nixos-anywhere.packages.${system}.default;
      });

    # Library helpers (overlay list, mkPkgs, directory discovery).
    lib = phixLib;

    # Overlays consumed by modules/core.nix and lib.mkPkgs.
    overlays = import ./overlays {inherit inputs;};

    # Real machines, discovered automatically from hosts/.
    nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;

    # Standalone Home Manager config, for any Linux x86_64 with Nix:
    #   home-manager switch --flake ~/.phix#standalone
    homeConfigurations.standalone = standaloneConfig;
  };
}
