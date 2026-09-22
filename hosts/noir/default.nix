#     _   __      _
#    / | / /___  (_)____
#   /  |/ / __ \/ / ___/
#  / /|  / /_/ / / /
# /_/ |_/\____/_/_/
# --------------------------------------
# Noir host nix configuration by lPhiNix
#
{inputs, ...}: {
  imports = [
    # Machine
    ./hardware.nix
    inputs.disko.nixosModules.disko
    ./disko.nix

    # Console / login experience
    ./console.nix
    ./ly.nix
  ];

  myConfig = {
    hostName = "noir";
    username = "phinix";
    profiles = ["laptop"];
    gpu = {
      provider = "nvidia";
      prime = {
        enable = true;
        nvidiaBusId = "PCI:1:0:0";
        igpu = "intel";
        igpuBusId = "PCI:0:2:0";
      };
    };
  };

  # Host-specific NixOS options
  time.timeZone = "Europe/Madrid";

  modules.gaming.enable = true;

  system.stateVersion = "26.05";
}
