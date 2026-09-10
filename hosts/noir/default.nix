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
    gpu = {
      provider = "nvidia";
      prime = {
        enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  # Enable the shared system modules required by this host.
  modules = {
    desktop.enable = true;
    audio.enable = true;
    network.enable = true;
    gaming.enable = true;
    home.enable = true;
  };

  system.stateVersion = "26.05";
}
