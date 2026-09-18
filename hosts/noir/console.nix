#  _   _       _         ____                      _
# | \ | | ___ (_)_ __   / ___|___  _ __  ___  ___ | | ___
# |  \| |/ _ \| | '__| | |   / _ \| '_ \/ __|/ _ \| |/ _ \
# | |\  | (_) | | |    | |__| (_) | | | \__ \ (_) | |  __/
# |_| \_|\___/|_|_|     \____\___/|_| |_|___/\___/|_|\___|
# --------------------------------------------------------
# Noir console (VT) nix configuration by lPhiNix
#
{pkgs, ...}: {
  # Keyboard layout for the virtual consoles.
  console.keyMap = "es";

  # Font applied as early as possible (in initrd) and on the consoles.
  console.earlySetup = true;
  console.packages = [pkgs.terminus_font];
  console.font = "ter-v20b";
}
