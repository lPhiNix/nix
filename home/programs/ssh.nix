#    _  ___        ____    __
#   / |/ (_)_ __  / __/__ / /
#  /    / /\ \ / _\ \(_-</ _ \
# /_/|_/_//_\_\ /___/___/_//_/
# -------------------------------------
# Ssh nix home client config by lPhiNix
#
{config, lib, ...}: {
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

      # GitHub: authenticate with the resident key (same identity used
      # for commit signing in programs/git.nix).
      "github.com" = {
        IdentityFile = "~/.ssh/id_ed25519_sk_rk_github";
        IdentitiesOnly = true;
        User = "git";
      };
    };
  };
}
