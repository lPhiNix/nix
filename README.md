# Phix

My personal declarative NixOS and Home Manager configuration for multiple hosts, integrating dotfiles, disk layouts with disko, and reproducible provisioning with nixos-anywhere. It runs on NixOS and on any Linux system with Nix.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/lPhiNix/phix/main/bootstrap.sh | bash
```

### Manual

```sh
git clone git@github.com:lPhiNix/phix.git ~/.phix
```

Then apply the configuration:

```sh
# NixOS
sudo nixos-rebuild switch --flake ~/.phix#$(hostname -s)

# other Linux (Home Manager)
home-manager switch --flake ~/.phix#standalone
```
