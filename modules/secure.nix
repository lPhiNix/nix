#  _   _ _        ____
# | \ | (_)_  __ / ___|  ___  ___ _   _ _ __ ___
# |  \| | \ \/ / \___ \ / _ \/ __| | | | '__/ _ \
# | |\  | |>  <   ___) |  __/ (__| |_| | | |  __/
# |_| \_|_/_/\_\ |____/ \___|\___|\__,_|_|  \___|
# -----------------------------------------------
# Nix secure module by lPhiNix
#
# Provides the host firewall, gated behind its own per-host feature toggle.
# Defaults to a default-deny policy with ping allowed; tunable per host.
#
{
  config,
  lib,
  ...
}: {
  options.modules.secure.enable = lib.mkEnableOption "Secure (firewall)";

  config = lib.mkIf config.modules.secure.enable {
    networking.firewall = {
      enable = lib.mkDefault true;
      allowPing = lib.mkDefault true;
      logRefusedConnections = lib.mkDefault true;
      checkReversePath = lib.mkDefault true;
    };
  };
}
