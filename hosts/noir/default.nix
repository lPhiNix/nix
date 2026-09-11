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
    consoleKeyMap = "es";
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

  modules.gaming.enable = true;

  system.stateVersion = "26.05";
}
