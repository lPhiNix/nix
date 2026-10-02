# Phix

My personal declarative NixOS and Home Manager configuration for multiple hosts, integrating dotfiles, disk layouts with disko, sops-nix secrets, and reproducible provisioning with nixos-anywhere. It runs on NixOS and on any Linux system with Nix.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/lPhiNix/phix/main/bootstrap.sh | bash
```

### Manual

```sh
git clone git@github.com:lPhiNix/phix.git ~/.phix
~/.phix/bootstrap.sh
```

## Usage

| Command                                  | Description                                                    |
| ---------------------------------------- | -------------------------------------------------------------- |
| `make switch HOST=<h>`                   | Rebuild and activate now (requires sudo).                      |
| `make boot HOST=<h>`                     | Stage the new configuration for the next boot (kernel/initrd). |
| `make test HOST=<h>`                     | Activate at runtime, without touching the boot entry.          |
| `make build HOST=<h>`                    | Build the configuration without activating it.                 |
| `make install HOST=<h> TARGET=root@<ip>` | Install NixOS on a fresh machine (wipes the disk).             |
| `make secrets HOST=<h>`                  | Edit the encrypted secrets of a host.                          |
| `make fmt`                               | Format all `.nix` files.                                       |
| `make update`                            | Update flake inputs, then format.                              |
| `make check`                             | Validate the whole flake.                                      |
