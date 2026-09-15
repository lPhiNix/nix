#    _  ___        ________
#   / |/ (_)_ __  / ___/ (_)
#  /    / /\ \ / / /__/ / /
# /_/|_/_//_\_\  \___/_/_/
# --------------------------------
# Cli nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    eza # Modern ls wrapper
    zoxide # Modern cd wrapper
    bat # Modern cat wrapper
    fd # Modern find wrapper
    ripgrep # Modern grep wrapper

    pkgs.unstablePkgs.yazi # Cli file manager

    fzf # Cli fuzzy finder

    btop # Cli system monitor

    curl # HTTP I/O tool
    wget # HTTP/FTP I/O tool

    jq # JSON interpreter

    trash-cli # Move files to trash

    tealdeer # Fast tldr client (simplified man pages)

    yubikey-manager # YubiKey device manager (ykman)
  ];
}
