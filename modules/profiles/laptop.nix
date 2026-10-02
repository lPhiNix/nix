#    __             __
#   / /  ___ ____  / /____  ___
#  / /__/ _ `/ _ \/ __/ _ \/ _ \
# /____/\_,_/ .__/\__/\___/ .__/
#          /_/           /_/
# ------------------------------
# Nix laptop profile by lPhiNix
#
# Sensible defaults for a laptop: a full desktop environment plus remote
# access and power management. Everything is mkDefault so a host can
# always override it.
#
{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (lib.elem "laptop" config.myConfig.profiles) {
    modules.desktop.enable = lib.mkDefault true;
    modules.audio.enable = lib.mkDefault true;
    modules.remote.enable = lib.mkDefault true;
    modules.secure.enable = lib.mkDefault true;
    modules.secrets.enable = lib.mkDefault true;
    modules.home.enable = lib.mkDefault true;
    modules.power.enable = lib.mkDefault true;
  };
}
