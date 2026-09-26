#    _  ___        ___           __
#   / |/ (_)_ __  / _ \__ _____ / /_
#  /    / /\ \ / / , _/ // (_-</ __/
# /_/|_/_//_\_\ /_/|_|\_,_/___/\__/
# ----------------------------------
# Rust nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.unstablePkgs.cargo # Rust build tool and package manager
    pkgs.unstablePkgs.rustc # Rust compiler
    pkgs.unstablePkgs.rustfmt # Rust code formatter
    pkgs.unstablePkgs.clippy # Rust linter (run via 'cargo clippy')
    pkgs.unstablePkgs.rust-analyzer # Rust language server
  ];
}
