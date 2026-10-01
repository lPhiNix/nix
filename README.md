# Phix

A multi-host NixOS flake: modular system and Home Manager configuration, integrated dotfiles, declarative disks (disko) and automated provisioning (nixos-anywhere), usable on NixOS or any Linux with Nix.

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

# other Linux (Home Manager; pick your architecture)
home-manager switch --flake ~/.phix#standalone-x86_64-linux
home-manager switch --flake ~/.phix#standalone-aarch64-linux
```
