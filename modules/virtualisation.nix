#  _   _ _       __     ___      _               _ _           _   _
# | \ | (_)_  __ \ \   / (_)_ __| |_ _   _  __ _| (_)___  __ _| |_(_) ___  _ __
# |  \| | \ \/ /  \ \ / /| | '__| __| | | |/ _` | | / __|/ _` | __| |/ _ \| '_ \
# | |\  | |>  <    \ V / | | |  | |_| |_| | (_| | | \__ \ (_| | |_| | (_) | | | |
# |_| \_|_/_/\_\    \_/  |_|_|   \__|\__,_|\__,_|_|_|___/\__,_|\__|_|\___/|_| |_|
# -------------------------------------------------------------------------------
# Nix virtualisation module by lPhiNix
#
# Groups the system-level virtualisation backends, gated behind their own
# feature toggles. Currently Docker (containers); future backends (e.g. libvirt
# for QEMU/KVM virtual machines) can be added here as sub-options.
#
{
  config,
  lib,
  ...
}: {
  options.modules.virtualisation.enable = lib.mkEnableOption "Virtualisation (Docker)";

  config = lib.mkIf config.modules.virtualisation.enable {
    # Docker daemon and client (the module adds 'docker' to system packages).
    virtualisation.docker.enable = true;

    # Run docker without sudo. Note: the docker group is effectively root.
    users.users.${config.myConfig.username}.extraGroups = ["docker"];
  };
}
