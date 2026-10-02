#     _   ___         __    _ __
#    / | / (_)  __   / /   (_) /_
#   /  |/ / / |/_/  / /   / / __ \
#  / /|  / />  <   / /___/ / /_/ /
# /_/ |_/_/_/|_|  /_____/_/_.___/
# --------------------------------
# Nix library helpers by lPhiNix
#
# Shared helpers for the flake outputs: build a nixpkgs instance with the
# project overlays, and discover the directories that describe a configuration.
#
{
  nixpkgs,
  self,
}: let
  inherit (nixpkgs) lib;

  # Ordered list of the project overlays (defined in overlays/default.nix).
  overlayList = [
    self.overlays.additions
    self.overlays.modifications
    self.overlays.unstable-packages
  ];
in {
  inherit overlayList;

  # nixpkgs for a system, with our overlays applied and unfree allowed.
  mkPkgs = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = overlayList;
    };

  # Names of the direct subdirectories of 'dir' that contain a default.nix.
  discovered = dir:
    lib.filter (name: builtins.pathExists (dir + "/${name}/default.nix"))
    (builtins.attrNames (builtins.readDir dir));
}
