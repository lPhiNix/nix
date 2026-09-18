#  _   _ _        ____  _          _ _
# | \ | (_)_  __ / ___|| |__   ___| | |
# |  \| | \ \/ / \___ \| '_ \ / _ \ | |
# | |\  | |>  <   ___) | | | |  __/ | |
# |_| \_|_/_/\_\ |____/|_| |_|\___|_|_|
# -------------------------------------
# Nix shell module by lPhiNix
#
# Registers the interactive shell used by the primary user account (see
# users.nix). Enabling it system-wide adds fish to /etc/shells and ships its
# completions.
#
{...}: {
  # Register fish as a system shell (adds it to /etc/shells and completions).
  programs.fish.enable = true;
}
