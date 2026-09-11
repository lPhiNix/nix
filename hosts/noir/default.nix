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
    ./hardware.nix

    inputs.disko.nixosModules.disko
    ./disko.nix
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
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  # Host-specific NixOS options
  console.keyMap = "es";
  time.timeZone = "Europe/Madrid";

  modules.gaming.enable = true;

  system.stateVersion = "26.05";
}
