#  _   _ _        ____  _          _ _
# | \ | (_)_  __ / ___|| |__   ___| | |
# |  \| | \ \/ / \___ \| '_ \ / _ \ | |
# | |\  | |>  <   ___) | | | |  __/ | |
# |_| \_|_/_/\_\ |____/|_| |_|\___|_|_|
# -------------------------------------
# Nix shell module by lPhiNix
#
# Provides the system-wide fish shell used by the primary user account (see
# users.nix).
#
{...}: {
  # Register fish as a system shell (adds it to /etc/shells and completions).
  programs.fish.enable = true;
}
