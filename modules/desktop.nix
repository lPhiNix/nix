#  _   _ _        ____            _    _
# | \ | (_)_  __ |  _ \  ___  ___| | _| |_ ___  _ __
# |  \| | \ \/ / | | | |/ _ \/ __| |/ / __/ _ \| '_ \
# | |\  | |>  <  | |_| |  __/\__ \   <| || (_) | |_) |
# |_| \_|_/_/\_\ |____/ \___||___/_|\_\\__\___/| .__/
#                                              |_|
# ----------------------------------------------------
# Nix desktop module by lPhiNix
#
# Provides the graphical desktop environment (Hyprland and its supporting
# services), gated behind its own per-host feature toggle. The display
# manager theme is intentionally host-specific (hosts/<name>/ly.nix).
#
{
  config,
  lib,
  ...
}: {
  options.modules.desktop.enable = lib.mkEnableOption "Desktop (Hyprland)";

  config = lib.mkIf config.modules.desktop.enable {
    # Hyprland Wayland compositor.
    programs.hyprland.enable = true;

    # Login manager: ly (TUI). Theme lives in the host (hosts/<name>/ly.nix).
    services.displayManager.ly = {
      enable = true;
      x11Support = false; # Hyprland / Wayland only
    };

    # Unlock the GNOME keyring automatically on login (password-based ly).
    security.pam.services.ly.enableGnomeKeyring = true;

    # Bluetooth support for devices and audio.
    hardware.bluetooth.enable = true;

    # Desktop services: geolocation, virtual filesystems, removable media.
    services.geoclue2.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
