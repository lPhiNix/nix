#    ____
#   / __/__ _____  _____ ____
#  _\ \/ -_) __/ |/ / -_) __/
# /___/\__/_/  |___/\__/_/
# -----------------------------
# Nix server profile by lPhiNix
#
# Sensible defaults for a headless server: remote access only, no desktop.
# Everything is mkDefault so a host can always override it.
#
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (lib.elem "server" config.myConfig.profiles) {
    modules.remote.enable = lib.mkDefault true;
    modules.secure.enable = lib.mkDefault true;
  };
}
