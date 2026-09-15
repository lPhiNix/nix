#    _  ___        ___
#   / |/ (_)_ __  / _ \___ _  __
#  /    / /\ \ / / // / -_) |/ /
# /_/|_/_//_\_\ /____/\__/|___/
# --------------------------------
# Dev nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim # Cli IDE

    opencode # Cli local/remote AI coding client

    direnv # Environments vars loader
  ];
}
