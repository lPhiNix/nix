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
  # Graphics follows the same toggle pattern as the other feature modules.
  # Enabled by default whenever a GPU is configured, but a host can override it.
  options.modules.graphics.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.myConfig.gpu.provider != null;
    description = "Graphics / GPU support (drivers, hardware acceleration).";
  };

  config = lib.mkMerge [
    # Base GPU acceleration, enabled for any provider.
    (lib.mkIf config.modules.graphics.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    # Intel iGPU: use the media driver for VA-API.
    (lib.mkIf (config.modules.graphics.enable && gpu.provider == "intel") {
      hardware.graphics.extraPackages = [pkgs.intel-media-driver];
    })

    # AMD GPU: use the AMDVLK Vulkan driver.
    (lib.mkIf (config.modules.graphics.enable && gpu.provider == "amd") {
      hardware.graphics.extraPackages = [pkgs.amdvlk];
    })

    # NVIDIA: open kernel module, modesetting and settings app.
    (lib.mkIf (config.modules.graphics.enable && gpu.provider == "nvidia") {
      services.xserver.videoDrivers = lib.mkDefault ["nvidia"];
      hardware.nvidia = {
        # Kernel module choice and power management (overrideable per host).
        open = gpu.nvidia.open;
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement = {
          enable = gpu.nvidia.powerManagement;
          finegrained = gpu.prime.enable;
        };
        # PRIME offload: render on NVIDIA, display via the integrated GPU.
        prime = lib.mkIf gpu.prime.enable ({
            offload.enable = true;
            offload.enableOffloadCmd = true;
            nvidiaBusId = gpu.prime.nvidiaBusId;
          }
          // (
            if gpu.prime.igpu == "intel"
            then {intelBusId = gpu.prime.igpuBusId;}
            else {amdgpuBusId = gpu.prime.igpuBusId;}
          ));
      };
    })

    # Fail early on inconsistent GPU / PRIME combinations.
    {
      assertions = [
        {
          assertion = !gpu.prime.enable || gpu.provider == "nvidia";
          message = "myConfig.gpu.prime.enable requires myConfig.gpu.provider = \"nvidia\".";
        }
        {
          assertion =
            !gpu.prime.enable
            || (gpu.prime.nvidiaBusId
              != ""
              && gpu.prime.igpu != null
              && gpu.prime.igpuBusId != "");
          message = "myConfig.gpu.prime.enable requires nvidiaBusId, igpu and igpuBusId.";
        }
        {
          assertion = !gpu.prime.enable || gpu.nvidia.powerManagement;
          message = "myConfig.gpu.prime.enable requires myConfig.gpu.nvidia.powerManagement = true (finegrained PRIME).";
        }
      ];
    }
  ];
}
