#  ____  _ _           _                   _
# | __ )| (_)________ | |__   __ _ _ __ __| |_      ____ _ _ __ ___
# |  _ \| | |_  /_  / | '_ \ / _` | '__/ _` \ \ /\ / / _` | '__/ _ \
# | |_) | | |/ / / /  | | | | (_| | | | (_| |\ V  V / (_| | | |  __/
# |____/|_|_/___/___| |_| |_|\__,_|_|  \__,_| \_/\_/ \__,_|_|  \___|
# -------------------------------------------------------------------
# Blizz hardware nix configuration by lPhiNix
#
{
  config,
  lib,
  modulesPath,
  ...
}: {
  # Catch hardware the installer did not detect automatically.
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # Storage/NVMe drivers the initrd needs to reach the LUKS container.
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];

  # AMD KVM module for hardware-accelerated virtual machines.
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # Install AMD CPU microcode updates (shipped with the firmware).
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
