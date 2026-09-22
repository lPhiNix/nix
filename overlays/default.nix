# Overlays applied to nixpkgs on every system (see modules/core.nix).
{inputs, ...}: {
  additions = final: _prev: import ../pkgs final;

  # Placeholder for overriding existing nixpkgs packages.
  modifications = final: prev: {};

  # Expose nixpkgs-unstable as pkgs.unstablePkgs (with unfree allowed).
  unstable-packages = final: _prev: {
    unstablePkgs = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # Expose the Caelestia shell+CLI as pkgs.caelestia, so the home modules do
  # not need to reach into the caelestia-cli flake input directly.
  caelestia-packages = final: _prev: {
    caelestia = inputs.caelestia-cli.packages.${final.stdenv.hostPlatform.system}.with-shell;
  };
}
