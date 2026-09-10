#  _   _ _        _   _      _                      _
# | \ | (_)_  __ | \ | | ___| |___      _____  _ __| | __
# |  \| | \ \/ / |  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ /
# | |\  | |>  <  | |\  |  __/ |_ \ V  V / (_) | |  |   <
# |_| \_|_/_/\_\ |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\
# -------------------------------------------------------
# Nix network module by lPhiNix
#
# Provides networking and remote access (SSH daemon and host firewall),
# gated behind its own per-host feature toggle.
#
{
  config,
  lib,
  ...
}: {
  options.modules.network.enable = lib.mkEnableOption "Network (OpenSSH)";

  config = lib.mkIf config.modules.network.enable {
    # SSH daemon restricted to key-based authentication.
    services.openssh = {
      enable = true;
      settings = {
        # Never allow root to log in via SSH.
        PermitRootLogin = "no";
        # Disable password logins; keys only.
        PasswordAuthentication = false;
      };
    };

    # Firewall on by default, but allow ICMP echo (ping).
    networking.firewall = {
      enable = lib.mkDefault true;
      allowPing = lib.mkDefault true;
    };
  };
}
