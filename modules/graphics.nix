#  _   _ _         ____                 _     _
# | \ | (_)_  __  / ___|_ __ __ _ _ __ | |__ (_) ___ ___
# |  \| | \ \/ / | |  _| '__/ _` | '_ \| '_ \| |/ __/ __|
# | |\  | |>  <  | |_| | | | (_| | |_) | | | | | (__\__ \
# |_| \_|_/_/\_\  \____|_|  \__,_| .__/|_| |_|_|\___|___/
#                                |_|
# -------------------------------------------------------
# Nix graphics module by lPhiNix
#
# Configures GPU support from myConfig.gpu: hardware acceleration for the
# chosen vendor and optional PRIME offload for hybrid laptops.
#
{
  config,
  lib,
  pkgs,
  ...
}: let
  gpu = config.myConfig.gpu;
in {
  config = lib.mkMerge [
    # Base GPU acceleration, enabled for any provider.
    (lib.mkIf (gpu.provider != null) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    # Intel iGPU: use the media driver for VA-API.
    (lib.mkIf (gpu.provider == "intel") {
      hardware.graphics.extraPackages = [pkgs.intel-media-driver];
    })

    # AMD GPU: use the AMDVLK Vulkan driver.
    (lib.mkIf (gpu.provider == "amd") {
      hardware.graphics.extraPackages = [pkgs.amdvlk];
    })

    # NVIDIA: open kernel module, modesetting and settings app.
    (lib.mkIf (gpu.provider == "nvidia") {
      services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
      hardware.nvidia = {
        # Use the open-source kernel module.
        open = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement = {
          enable = true;
          finegrained = gpu.prime.enable;
        };
        # PRIME offload: render on NVIDIA, display via the Intel iGPU.
        prime = lib.mkIf gpu.prime.enable {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          nvidiaBusId = gpu.prime.nvidiaBusId;
          intelBusId = gpu.prime.intelBusId;
        };
      };
    })

    # Fail early if PRIME is enabled without its bus IDs.
    {
      assertions = [
        {
          assertion =
            gpu.provider
            != "nvidia"
            || !gpu.prime.enable
            || (gpu.prime.nvidiaBusId != "" && gpu.prime.intelBusId != "");
          message = "myConfig.gpu.prime.enable requires nvidiaBusId and intelBusId.";
        }
      ];
    }
  ];
}
