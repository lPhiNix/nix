#    _  ___        ___       __  __
#   / |/ (_)_ __  / _ \__ __/ /_/ /  ___  ___
#  /    / /\ \ / / ___/ // / __/ _ \/ _ \/ _ \
# /_/|_/_//_\_\ /_/   \_, /\__/_//_/\___/_//_/
#                    /___/
# --------------------------------------------
# Python nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    python3 # Python 3 interpreter
    pkgs.unstablePkgs.uv # Fast Python package and virtualenv manager
  ];
}
