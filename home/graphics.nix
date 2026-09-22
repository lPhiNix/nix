#    _  ___        _____              __   _
#   / |/ (_)_ __  / ___/______ ____  / /  (_)______
#  /    / /\ \ / / (_ / __/ _ `/ _ \/ _ \/ / __(_-<
# /_/|_/_//_\_\  \___/_/  \_,_/ .__/_//_/_/\__/___/
#                            /_/
# -------------------------------------------------
# Graphics nix home pakages by lPhiNix
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.mkIf config.features.graphics (with pkgs; [
    mesa-demos # Mesa OpenGL demo/test utilities
    vulkan-tools # Vulkan info/diagnostic tools
  ]);
}
