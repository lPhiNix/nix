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
  pkgs,
  ...
}: {
  options.modules.gaming.enable = lib.mkEnableOption "Gaming (Steam)";

  config = lib.mkIf config.modules.gaming.enable {
    # Steam with 32-bit libraries and hardware acceleration.
    programs.steam = {
      enable = true;
    };

    # nix-ld: lets generic dynamically-linked binaries run on NixOS, whose
    # interpreter path (/lib64/ld-linux-x86-64.so.2) does not exist here.
    programs.nix-ld = {
      enable = true;
      # Extra libs on top of the module's defaults: X11, GL, audio and fonts.
      libraries = with pkgs; [
        libx11
        libxext
        libxrender
        libxtst
        libxi
        libxcursor
        libxrandr
        libxinerama
        libxxf86vm
        libglvnd
        libpulseaudio
        alsa-lib
        udev
        fontconfig
        freetype
        wayland
        libxkbcommon
        libdecor
      ];
    };
  };
}
