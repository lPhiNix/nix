#    _  ___        _______   ____
#   / |/ (_)_ __  / ___/ /  /  _/
#  /    / /\ \ / / /__/ /___/ /
# /_/|_/_//_\_\  \___/____/___/
# --------------------------------
# CLI nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    eza # Modern ls wrapper
    zoxide # Modern cd wrapper
    bat # Modern cat wrapper
    fd # Modern find wrapper
    ripgrep # Modern grep wrapper

    pkgs.unstablePkgs.yazi # CLI file manager

    fzf # CLI fuzzy finder

    btop # CLI system monitor

    curl # HTTP I/O tool
    wget # HTTP/FTP I/O tool

    jq # JSON interpreter

    trash-cli # Move files to trash

    tealdeer # Fast tldr client (simplified man pages)

    yubikey-manager # YubiKey device manager (ykman)
    pcsc-tools # PC/SC smart card diagnostics (pcsc_scan)
  ];
}
