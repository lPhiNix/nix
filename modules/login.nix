#  _   _ _        _                _
# | \ | (_)_  __ | |    ___   __ _(_)_ __
# |  \| | \ \/ / | |   / _ \ / _` | | '_ \
# | |\  | |>  <  | |__| (_) | (_| | | | | |
# |_| \_|_/_/\_\ |_____\___/ \__, |_|_| |_|
#                            |___/
# ------------------------------------------
# Nix login module by lPhiNix
#
# Creates the primary user account. Authentication (password, SSH keys) is
# intentionally host-specific: add authorizedKeys or a hashedPasswordFile to
# the host once logins are set up, so no credentials live in the base layer.
#
{config, ...}: {
  users.users.${config.myConfig.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"] ++ config.myConfig.extraGroups;
  };

  # Allow `passwd` to set a password on first boot. Swap this for
  # users.users.<name>.hashedPasswordFile once secrets are introduced.
  users.mutableUsers = true;
}
