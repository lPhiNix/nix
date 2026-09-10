#  _   _ _           _             _ _
# | \ | (_)_  __    / \  _   _  __| (_) ___
# |  \| | \ \/ /   / _ \| | | |/ _` | |/ _ \
# | |\  | |>  <   / ___ \ |_| | (_| | | (_) |
# |_| \_|_/_/\_\ /_/   \_\__,_|\__,_|_|\___/
# -------------------------------------------
# Nix audio module by lPhiNix
#
# Provides audio support (PipeWire with PulseAudio compatibility), gated
# behind its own per-host feature toggle.
#
{
  config,
  lib,
  ...
}: {
  options.modules.audio.enable = lib.mkEnableOption "Audio (PipeWire)";

  config = lib.mkIf config.modules.audio.enable {
    # PipeWire audio server with PulseAudio compatibility.
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
