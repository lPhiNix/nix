#  _   _ _         ___        _   _
# | \ | (_)_  __  / _ \ _ __ | |_(_) ___  _ __  ___
# |  \| | \ \/ / | | | | '_ \| __| |/ _ \| '_ \/ __|
# | |\  | |>  <  | |_| | |_) | |_| | (_) | | | \__ \
# |_| \_|_/_/\_\  \___/| .__/ \__|_|\___/|_| |_|___/
#                      |_|
# --------------------------------------------------
# Home feature toggles by lPhiNix
#
# Typed switches for the optional home package sets. The feature names live
# here; inside NixOS they mirror the modules.*.enable booleans and in
# standalone a config sets them directly (home/standalone.nix), so the same home
# modules work in both contexts.
#
{
  config,
  lib,
  osConfig ? null,
  ...
}: let
  # Single source of the feature names.
  features = ["desktop" "gaming" "graphics" "virtualisation"];
in {
  # One typed enable switch per feature.
  options.features =
    lib.genAttrs features
    (name: lib.mkEnableOption "${name} home packages");

  # Inside NixOS, mirror the system modules.<name>.enable switches. In
  # standalone (osConfig == null) the config sets them directly.
  config = lib.mkIf (osConfig != null) {
    assertions =
      map (name: {
        assertion = builtins.hasAttr name osConfig.modules;
        message = "home feature '${name}' has no matching modules.${name}.enable option.";
      })
      features;

    features =
      lib.genAttrs features
      (name: osConfig.modules.${name}.enable);
  };
}
