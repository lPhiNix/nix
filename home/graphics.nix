#    _  ___        _____              __   _
#   / |/ (_)_ __  / ___/______ ____  / /  (_)______
#  /    / /\ \ / / (_ / __/ _ `/ _ \/ _ \/ / __(_-<
# /_/|_/_//_\_\  \___/_/  \_,_/ .__/_//_/_/\__/___/
#                            /_/
# -------------------------------------------------
# Graphics nix home pakages by lPhiNix
#
{
  lib,
  pkgs,
  nixosConfig,
  ...
}: {
  home.packages = lib.mkIf (nixosConfig.myConfig.gpu.provider != null) (with pkgs; [
    mesa-demos # Mesa OpenGL demo/test utilities
    vulkan-tools # Vulkan info/diagnostic tools
  ]);
}
