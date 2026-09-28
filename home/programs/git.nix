#    _  ___        ______ __
#   / |/ (_)_ __  / ___(_) /_
#  /    / /\ \ / / (_ / / __/
# /_/|_/_//_\_\  \___/_/\__/
# ------------------------------------------
# Git nix home package and config by lPhiNix
#
{config, ...}: {
  programs.git = {
    enable = true;
    settings = {
      # Committer identity for all git commits.
      user.name = "lPhiNix";
      user.email = "152783810+lPhiNix@users.noreply.github.com";

      # Default branch
      init.defaultBranch = "main";

      # Pull behaviour (always rebase)
      pull.rebase = true;

      # Always prune deleted remote branches on fetch.
      fetch.prune = true;

      # Editor used for commit messages and interactive rebases.
      core.editor = "nvim";

      # Force SSH for github.com instead of HTTPS
      url."git@github.com:".insteadOf = "https://github.com/";

      # Sign commits/tags with the SSH key stored on physical key.
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519_sk_rk_github";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };

    # Store large files via Git LFS.
    lfs.enable = true;

    # Global ignores applied to every repository.
    ignores = [
      "*.swp"
      "*~"
      ".DS_Store"
    ];
  };
}
