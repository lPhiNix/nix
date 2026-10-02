#    _  ___        ____
#   / |/ (_)_ __  / __/__  ___  ___
#  /    / /\ \ / _\ \/ _ \/ _ \(_-<
# /_/|_/_//_\_\ /___/\___/ .__/___/
#                       /_/
# ---------------------------------
# Sops nix home packages by lPhiNix
#
# Admin tooling to create and edit the encrypted secrets, plus the user's SSH
# identity wired from the system secrets capability (modules/secrets.nix).
#
{
  config,
  osConfig ? null,
  lib,
  pkgs,
  ...
}: let
  enabled = osConfig != null && osConfig.modules.secrets.enable;
in {
  # Link the system-managed private key into ~/.ssh. mkOutOfStoreSymlink is
  # required: the key lives at runtime (/run/secrets), not in the store; a
  # normal source would copy it into the world-readable store.
  home.file = lib.optionalAttrs enabled {
    ".ssh/id_ed25519".source =
      config.lib.file.mkOutOfStoreSymlink osConfig.modules.secrets.paths.userKey;
  };

  # sops (encrypt/decrypt), age (keygen), age-plugin-yubikey (admin identity
  # stored on the YubiKey PIV).
  home.packages = lib.optionals enabled (with pkgs; [
    sops
    age
    age-plugin-yubikey
  ]);
}
