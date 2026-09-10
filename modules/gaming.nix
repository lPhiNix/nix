#  _   _ _         ____                 _
# | \ | (_)_  __  / ___| __ _ _ __ ___ (_)_ __   __ _
# |  \| | \ \/ / | |  _ / _` | '_ ` _ \| | '_ \ / _` |
# | |\  | |>  <  | |_| | (_| | | | | | | | | | | (_| |
# |_| \_|_/_/\_\  \____|\__,_|_| |_| |_|_|_| |_|\__, |
#                                               |___/
# ----------------------------------------------------
# Nix gaming module by lPhiNix
#
# Provides gaming support (Steam and its runtime), gated behind its own
# per-host feature toggle.
#
{
  config,
  lib,
  ...
}: {
  options.modules.gaming.enable = lib.mkEnableOption "Gaming (Steam)";

  config = lib.mkIf config.modules.gaming.enable {
    # Steam with 32-bit libraries and hardware acceleration.
    programs.steam = {
      enable = true;
    };
  };
}
