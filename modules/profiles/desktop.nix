#    ___          __   __
#   / _ \___ ___ / /__/ /____  ___
#  / // / -_|_-</  '_/ __/ _ \/ _ \
# /____/\__/___/_/\_\\__/\___/ .__/
#                           /_/
# ---------------------------------
# Nix desktop profile by lPhiNix
#
# Sensible defaults for a desktop machine: a full desktop environment plus
# remote access. Everything is mkDefault so a host can always override it.
#
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (lib.elem "desktop" config.myConfig.profiles) {
    modules.desktop.enable = lib.mkDefault true;
    modules.audio.enable = lib.mkDefault true;
    modules.network.enable = lib.mkDefault true;
    modules.home.enable = lib.mkDefault true;
  };
}
