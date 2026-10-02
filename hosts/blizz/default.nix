#     ____  ___
#    / __ )/ (_)_______
#   / __  / / /_  /_  /
#  / /_/ / / / / /_/ /_
# /_____/_/_/ /___/___/
# ---------------------------------------
# Blizz host nix configuration by lPhiNix
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
    profiles = ["desktop"];
    gpu = {
      # Discrete RTX 5070 does the rendering; the AMD iGPU is left unused
      # (the monitor is plugged into the NVIDIA card).
      provider = "nvidia";
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
