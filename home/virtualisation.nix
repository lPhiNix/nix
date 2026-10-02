#    _  ___        _   ___     __            ___          __  _
#   / |/ (_)_ __  | | / (_)___/ /___ _____ _/ (_)__ ___ _/ /_(_)__  ___
#  /    / /\ \ /  | |/ / / __/ __/ // / _ `/ / (_-</ _ `/ __/ / _ \/ _ \
# /_/|_/_//_\_\   |___/_/_/  \__/\_,_/\_,_/_/_/___/\_,_/\__/_/\___/_//_/
# ----------------------------------------------------------------------
# Virtualisation nix home packages by lPhiNix
#
# User-space virtualisation tooling. The Docker daemon lives in the system
# layer (modules/virtualisation.nix); here only its client plugins are added.
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.features.virtualisation (with pkgs; [
    docker-compose # Compose v2 plugin (docker compose)
    docker-buildx # Buildx plugin (docker buildx)
  ]);
}
