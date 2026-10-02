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

  # Unlock the root LUKS (main) with the YubiKey FIDO2 token; the passphrase
  # stays enrolled as a fallback.
  boot.initrd.luks.devices."main".crypttabExtraOpts = ["fido2-device=auto" "token-timeout=5"];

  modules.gaming.enable = true;
  modules.virtualisation.enable = true;

  system.stateVersion = "26.05";
}
