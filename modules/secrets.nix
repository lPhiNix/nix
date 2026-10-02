#  _   _ _        ____                     _
# | \ | (_)_  __ / ___|  ___  ___ _ __ ___| |_ ___
# |  \| | \ \/ / \___ \ / _ \/ __| '__/ _ \ __/ __|
# | |\  | |>  <   ___) |  __/ (__| | |  __/ |_\__ \
# |_| \_|_/_/\_\ |____/ \___|\___|_|  \___|\__|___/
# -------------------------------------------------
# Nix secrets module by lPhiNix
#
# Declarative secret management (sops-nix) as a capability. Secrets live
# encrypted in the repo and are decrypted at activation; the canonical
# identifiers are owned here and exposed to consumers through
# modules.secrets.paths, so no other module knows about sops. Each host
# decrypts with its own age key (injected at install); admins edit with a
# YubiKey.
#
{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.secrets;

  # Canonical identifiers, defined once. '/' maps to nested YAML keys
  # (sops-nix splits on it); consumers never repeat these strings.
  names = {
    userKey = "ssh/id_ed25519";
    hostKey = "ssh/host_ed25519";
    passwordHash = "password-hash";
  };
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options.modules.secrets = {
    enable = lib.mkEnableOption "Secrets (sops-nix)";

    # Resolved paths, the only surface consumers depend on.
    paths = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Paths of the managed secrets, for consumers.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Host age key: the machine's private identity, at a persistent path
    # (inside LUKS). Injected at install; never in the store (world-readable).
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    # Only the injected key is an identity. Otherwise sops would try to import
    # the SSH host key below (itself a sops secret) as an age key: a catch-22
    # at activation.
    sops.age.sshKeyPaths = [];
    sops.defaultSopsFormat = "yaml";
    # One sops file per host, derived from the hostname.
    sops.defaultSopsFile = ../hosts/${config.networking.hostName}/secrets.yaml;

    # SSH server identity (private). Stable across reinstalls so clients can
    # pin it; sshd reads it via services.openssh.hostKeys.
    sops.secrets.${names.hostKey} = {
      path = "/etc/ssh/ssh_host_ed25519_key";
      mode = "0600";
    };

    # Login password hash. Decrypted before users exist, because
    # hashedPasswordFile is read at user creation.
    sops.secrets.${names.passwordHash}.neededForUsers = true;

    # User SSH identity (private), owned by the primary user; used to log into
    # other hosts (their authorized_keys list this key's public half).
    sops.secrets.${names.userKey} = {
      owner = config.myConfig.username;
      mode = "0600";
    };

    modules.secrets.paths = {
      userKey = config.sops.secrets.${names.userKey}.path;
      hostKey = config.sops.secrets.${names.hostKey}.path;
      passwordHash = config.sops.secrets.${names.passwordHash}.path;
    };
  };
}
