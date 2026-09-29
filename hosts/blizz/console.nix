#  ____  _ _                                     _
# | __ )| (_)________   ___ ___  _ __  ___  ___ | | ___
# |  _ \| | |_  /_  /  / __/ _ \| '_ \/ __|/ _ \| |/ _ \
# | |_) | | |/ / / /  | (_| (_) | | | \__ \ (_) | |  __/
# |____/|_|_/___/___|  \___\___/|_| |_|___/\___/|_|\___|
# ------------------------------------------------------
# Blizz console (VT) nix configuration by lPhiNix
#
{pkgs, ...}: {
  # Keyboard layout for the virtual consoles.
  console.keyMap = "es";

  # Font applied as early as possible (in initrd) and on the consoles.
  console.earlySetup = true;
  console.packages = [pkgs.terminus_font];
  console.font = "ter-v20b";
}
