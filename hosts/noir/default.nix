#     _   __      _         ______            _____
#    / | / /___  (_)____   / ____/___  ____  / __(_)___ _
#   /  |/ / __ \/ / ___/  / /   / __ \/ __ \/ /_/ / __ `/
#  / /|  / /_/ / / /     / /___/ /_/ / / / / __/ / /_/ /
# /_/ |_/\____/_/_/      \____/\____/_/ /_/_/ /_/\__, /
#                                               /____/
# -------------------------------------------------------
# Noir host nix configuration by lPhiNix
#
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Hostname used as the flake target (nixos-rebuild .#noir).
  networking.hostName = "noir";

  # Primary user with sudo and NetworkManager access.
  users.users.phinix = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
  };

  # Enable the shared system modules required by this host.
  modules = {
    desktop.enable = true;
    audio.enable = true;
    network.enable = true;
    gaming.enable = true;
    home.enable = true;

    graphics = {
      # Use the NVIDIA GPU for rendering.
      provider = "nvidia";
      nvidia = {
        # PCI BusIDs required for PRIME offload.
        busId = "PCI:1:0:0";
        iGpuBusId = "PCI:0:2:0";
      };
    };
  };
}
