#    _  ___        ___
#   / |/ (_)_ __  / _ \_______  ___ ________ ___ _  ___
#  /    / /\ \ / / ___/ __/ _ \/ _ `/ __/ _ `/  ' \(_-<
# /_/|_/_//_\_\ /_/  /_/  \___/\_, /_/  \_,_/_/_/_/___/
#                             /___/
# -----------------------------------------------------
# Nix home programs by lPhiNix
#
{...}: {
  # Aggregates the per-program Home Manager modules.
  imports = [
    ./git.nix
    ./ssh.nix
    ./java.nix
    ./python.nix
    ./rust.nix
    ./cc.nix
    ./go.nix
    ./dotnet.nix
    ./lua.nix
    ./kotlin.nix
    ./node.nix
    ./android.nix
    ./caelestia.nix
    ./sops.nix
  ];
}
