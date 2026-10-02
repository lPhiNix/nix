#  _   _ _        ____                      _
# | \ | (_)_  __ |  _ \ ___ _ __ ___   ___ | |_ ___
# |  \| | \ \/ / | |_) / _ \ '_ ` _ \ / _ \| __/ _ \
# | |\  | |>  <  |  _ <  __/ | | | | | (_) | ||  __/
# |_| \_|_/_/\_\ |_| \_\___|_| |_| |_|\___/ \__\___|
# --------------------------------------------------
# Nix remote module by lPhiNix
#
# Provides the OpenSSH server, gated behind its own per-host feature toggle.
# The baseline is key-only authentication; the rest is tunable per host.
#
{
  config,
  lib,
  ...
}: {
  options.modules.remote.enable = lib.mkEnableOption "Remote (OpenSSH server)";

  config = lib.mkIf config.modules.remote.enable {
    services.openssh = {
      enable = true;

      # Tunable per host (hosts/<name>/default.nix).
      startWhenNeeded = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
      ports = lib.mkDefault [22];

      settings = lib.mkMerge [
        # Enforced baseline: key-only, no root, no empty passwords.
        {
          AuthenticationMethods = "publickey";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          PermitEmptyPasswords = false;
        }

        # Overridable base.
        (lib.mkDefault {
          AllowUsers = [config.myConfig.username];
          AllowAgentForwarding = false;
          X11Forwarding = false;
          PermitTunnel = "no";
          GatewayPorts = "no";
          UseDNS = "no";
          MaxAuthTries = 3;
          MaxStartups = "3:50:10";
          PerSourceMaxStartups = 3;
          LoginGraceTime = 20;
        })
      ];
    };
  };
}
