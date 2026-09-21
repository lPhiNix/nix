#  _   _ _         ____
# | \ | (_)_  __  / ___|___  _ __ ___
# |  \| | \ \/ / | |   / _ \| '__/ _ \
# | |\  | |>  <  | |__| (_) | | |  __/
# |_| \_|_/_/\_\  \____\___/|_|  \___|
# ------------------------------------
# Nix core module by lPhiNix
#
# Provides the base system configuration shared by every machine: nixpkgs
# policy, the Nix daemon, the bootloader, networking, firmware, udev rules
# and locales. Host-specific values are provided through myConfig.
#
{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Nixpkgs options: allow unfree software and apply our custom overlays.
  nixpkgs = {
    config = {
      # Allow proprietary software (e.g. Steam, browsers).
      allowUnfree = true;
    };
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
  };

  # Nix daemon/client settings: flakes enabled, store auto-optimised.
  nix = {
    settings = {
      # Enable the experimental flakes and nix-command features.
      experimental-features = "nix-command flakes";
      # Disable the flake registry; require full URLs.
      flake-registry = "";
      # Automatically deduplicate identical store paths.
      auto-optimise-store = true;
    };
    # No channels; the flake is the single source of truth.
    channel.enable = false;

    # Automatic garbage collection: delete generations and store paths
    # older than 7 days (the generation active then is preserved).
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot via systemd-boot and let nixos-rebuild manage EFI vars.
  boot.loader.systemd-boot = {
    enable = lib.mkDefault true;
    # Keep only the 10 most recent generations in the boot menu.
    configurationLimit = lib.mkDefault 10;
  };
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Manage networking via NetworkManager.
  networking.networkmanager.enable = true;

  # Allow non-redistributable firmware blobs.
  hardware.enableRedistributableFirmware = true;

  # Shared defaults for host data. Any host can override these directly
  time.timeZone = lib.mkDefault "Europe/Madrid";
  console.keyMap = lib.mkDefault "us";

  # Smart card (CCID) support: OATH, PIV and OpenPGP over PC/SC.
  services.pcscd.enable = true;

  # udev rules for YubiKey devices.
  services.udev.packages = [pkgs.yubikey-personalization];

  # Supported locales.
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "es_ES.UTF-8/UTF-8"];
}
