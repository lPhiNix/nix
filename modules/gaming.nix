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
      # Force PRIME render offload (NVIDIA dGPU) on Steam and the games it
      # launches, mirroring the nvidia-offload wrapper. Only applies on hosts
      # where PRIME is enabled; elsewhere Steam keeps its defaults.
      package = lib.mkIf config.myConfig.gpu.prime.enable (
        pkgs.steam.override {
          extraEnv = {
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          };
        }
      );
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
