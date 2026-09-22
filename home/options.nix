#  _   _ _         ___        _   _
# | \ | (_)_  __  / _ \ _ __ | |_(_) ___  _ __  ___
# |  \| | \ \/ / | | | | '_ \| __| |/ _ \| '_ \/ __|
# | |\  | |>  <  | |_| | |_) | |_| | (_) | | | \__ \
# |_| \_|_/_/\_\  \___/| .__/ \__|_|\___/|_| |_|___/
#                      |_|
# --------------------------------------------------
# Home feature toggles by lPhiNix
#
# Typed switches for the optional home package sets. They are set from the
# NixOS modules.*.enable booleans (home/default.nix) or directly when used
# standalone (flake.nix), so the same home modules work in both contexts.
#
{lib, ...}: {
  options.features = {
    desktop = lib.mkEnableOption "desktop home packages";
    gaming = lib.mkEnableOption "gaming home packages";
    graphics = lib.mkEnableOption "graphics home packages";
  };
}
