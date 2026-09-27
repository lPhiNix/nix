#  _   _ _        ____            _
# | \ | (_)_  __ |  _ \ __ _  ___| | ____ _  __ _  ___  ___
# |  \| | \ \/ / | |_) / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
# | |\  | |>  <  |  __/ (_| | (__|   < (_| | (_| |  __/\__ \
# |_| \_|_/_/\_\ |_|   \__,_|\___|_|\_\__,_|\__, |\___||___/
#                                           |___/
# ----------------------------------------------------------
# Nix custom packages configuration by lPhiNix
#
pkgs: {
  # Official prebuilt ATLauncher jar (fixes the broken source build).
  atlauncher-bin = pkgs.callPackage ./gaming/atlauncher-bin.nix {};
}
