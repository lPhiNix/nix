#  _   _ _         ___                 _
# | \ | (_)_  __  / _ \__   _____ _ __| | __ _ _   _ ___
# |  \| | \ \/ / | | | \ \ / / _ \ '__| |/ _` | | | / __|
# | |\  | |>  <  | |_| |\ V /  __/ |  | | (_| | |_| \__ \
# |_| \_|_/_/\_\  \___/  \_/ \___|_|  |_|\__,_|\__, |___/
#                                              |___/
# -------------------------------------------------------
# Nix overlays configuration by lPhiNix
#
# Overlays applied to nixpkgs on every system (see modules/core.nix).
#
{inputs, ...}: {
  additions = final: _prev: import ../pkgs final;

  # Placeholder for overriding existing nixpkgs packages.
  modifications = final: _prev: {};

  # Expose nixpkgs-unstable as pkgs.unstablePkgs (with unfree allowed).
  unstable-packages = final: _prev: {
    unstablePkgs = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
