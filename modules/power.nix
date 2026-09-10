#  _   _ _        ____
# | \ | (_)_  __ |  _ \ _____      _____ _ __
# |  \| | \ \/ / | |_) / _ \ \ /\ / / _ \ '__|
# | |\  | |>  <  |  __/ (_) \ V  V /  __/ |
# |_| \_|_/_/\_\ |_|   \___/ \_/\_/ \___|_|
# --------------------------------------------
# Nix power module by lPhiNix
#
# Provides power management: battery reporting (upower) and CPU power
# profiles (power-profiles-daemon). Gated behind its own feature toggle,
# enabled by the laptop profile.
#
{
  config,
  lib,
  ...
}: {
  options.modules.power.enable = lib.mkEnableOption "Power management (battery, CPU profiles)";

  config = lib.mkIf config.modules.power.enable {
    # Battery reporting and CPU power profiles.
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
