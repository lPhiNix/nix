#  _   _ _        _   _
# | \ | (_)_  __ | | | |___  ___ _ __ ___
# |  \| | \ \/ / | | | / __|/ _ \ '__/ __|
# | |\  | |>  <  | |_| \__ \  __/ |  \__ \
# |_| \_|_/_/\_\  \___/|___/\___|_|  |___/
# ----------------------------------------
# Nix users module by lPhiNix
#
# Creates the primary user account. SSH authorized keys stay host-specific
# (hosts/<name>/keys.nix); the login password comes from the secrets
# capability when it is enabled.
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.${config.myConfig.username} =
    {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "kvm"] ++ config.myConfig.extraGroups;
      shell = pkgs.fish; # registered system-wide in shell.nix
    }
    // lib.optionalAttrs config.modules.secrets.enable {
      # Declarative password read from the secret at activation: no manual
      # 'passwd' and no first-boot lockout.
      hashedPasswordFile = config.modules.secrets.paths.passwordHash;
    };

  # A declarative password requires an immutable account.
  users.mutableUsers = !config.modules.secrets.enable;
}
