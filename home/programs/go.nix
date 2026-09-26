#    _  ___        _____
#   / |/ (_)_ __  / ___/__
#  /    / /\ \ / / (_ / _ \
# /_/|_/_//_\_\  \___/\___/
# -------------------------------
# Go nix home packages by lPhiNix
#
{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    go # Go compiler and toolchain
    pkgs.unstablePkgs.gopls # Go language server
    delve # Go debugger (dlv)
  ];

  # Keep Go modules/cache under XDG dirs and expose 'go install' binaries on PATH.
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
    GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
  };
  home.sessionPath = ["${config.home.homeDirectory}/.local/share/go/bin"];
}
