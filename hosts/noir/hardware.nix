#  _   _       _        _   _               _
# | \ | | ___ (_)_ __  | | | | __ _ _ __ __| |_      ____ _ _ __ ___
# |  \| |/ _ \| | '__| | |_| |/ _` | '__/ _` \ \ /\ / / _` | '__/ _ \
# | |\  | (_) | | |    |  _  | (_| | | | (_| |\ V  V / (_| | | |  __/
# |_| \_|\___/|_|_|    |_| |_|\__,_|_|  \__,_| \_/\_/ \__,_|_|  \___|
# -------------------------------------------------------------------
# Noir hardware nix configuration by lPhiNix
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
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];

  # Intel KVM module for hardware-accelerated virtual machines.
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Install Intel CPU microcode updates (shipped with the firmware).
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
