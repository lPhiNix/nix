#    _  ___        ____    __
#   / |/ (_)_ __  / __/__ / /
#  /    / /\ \ / _\ \(_-</ _ \
# /_/|_/_//_\_\ /___/___/_//_/
# -------------------------------------
# Ssh nix home client config by lPhiNix
#
# YubiKey resident keys (FIDO2). Enroll one per purpose/host with:
#
#   ssh-keygen -t ed25519-sk -O resident -O verify-required \
#     -O application=ssh:<name> -C "<name>" \
#     -f ~/.ssh/id_ed25519_sk_rk_<name>
#
# On any other machine download all of them with `ssh-keygen -K`; that writes
# ~/.ssh/id_ed25519_sk_rk_<name> with comment "ssh:<name>". To remove a stale
# credential before re-enrolling:
#
#   ykman fido credentials list
#   ykman fido credentials delete <id>
#
# Then reference each key with `IdentityFile` under its matching Host block.
#
{
  config,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;

    # Declare the legacy implicit defaults explicitly instead of letting
    # home-manager inject them (the implicit set is deprecated upstream).
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      # GitHub uses the resident key enrolled with application "ssh:github"
      # (see the YubiKey notes at the top). Same identity as the commit
      # signing key in programs/git.nix.
      "github.com" = {
        IdentityFile = "~/.ssh/id_ed25519_sk_rk_github";
        IdentitiesOnly = true;
        User = "git";
      };
    };
  };
}
