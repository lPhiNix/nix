#  _   _ _        _   _
# | \ | (_)_  __ | | | |___  ___ _ __ ___
# |  \| | \ \/ / | | | / __|/ _ \ '__/ __|
# | |\  | |>  <  | |_| \__ \  __/ |  \__ \
# |_| \_|_/_/\_\  \___/|___/\___|_|  |___/
# ----------------------------------------
# Nix users module by lPhiNix
#
# Creates the primary user account. Authentication (password, SSH keys) is
# intentionally host-specific: add authorizedKeys or a hashedPasswordFile to
# the host once logins are set up, so no credentials live in the base layer.
#
{
  config,
  pkgs,
  ...
}: {
  users.users.${config.myConfig.username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"] ++ config.myConfig.extraGroups;
    shell = pkgs.fish; # registered system-wide in shell.nix
  };

  # Allow `passwd` to set a password on first boot. Swap this for
  # users.users.<name>.hashedPasswordFile once secrets are introduced.
  users.mutableUsers = true;
}
