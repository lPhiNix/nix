#    _  ___        ___           __
#   / |/ (_)_ __  / _ \__ _____ / /_
#  /    / /\ \ / / , _/ // (_-</ __/
# /_/|_/_//_\_\ /_/|_|\_,_/___/\__/
# ----------------------------------
# Rust nix home packages by lPhiNix
#
{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo # Rust build tool and package manager
    rustc # Rust compiler
    rustfmt # Rust code formatter
    clippy # Rust linter (run via 'cargo clippy')
    rust-analyzer # Rust language server
  ];
}
