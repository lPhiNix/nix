# Nix

My personal Nix configuration: a NixOS system plus a portable Home Manager
layer usable on any other Linux distro.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/lPhiNix/nix/main/bootstrap.sh | bash
```

### Manual

```sh
git clone git@github.com:lPhiNix/nix.git ~/.nix
```

Then apply the configuration:

```sh
# NixOS
sudo nixos-rebuild switch --flake ~/.nix#$(hostname -s)

# other Linux (Home Manager; pick your architecture)
home-manager switch --flake ~/.nix#standalone-x86_64-linux
home-manager switch --flake ~/.nix#standalone-aarch64-linux
```
