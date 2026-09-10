#     _   __      _         ______            _____
#    / | / /___  (_)____   / ____/___  ____  / __(_)___ _
#   /  |/ / __ \/ / ___/  / /   / __ \/ __ \/ /_/ / __ `/
#  / /|  / /_/ / / /     / /___/ /_/ / / / / __/ / /_/ /
# /_/ |_/\____/_/_/      \____/\____/_/ /_/_/ /_/\__, /
#                                               /____/
# -------------------------------------------------------
# Noir host nix configuration by lPhiNix
#
{...}: {
  imports = [./hardware-configuration.nix];

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
