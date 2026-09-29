#    _  ___                        ____        __  ___     __       ____ __
#   / |/ (_)_ _____________  ___  / _(_)__ _  /  |/  /__ _/ /_____ / _(_) /__
#  /    / /\ \ /___/ __/ _ \/ _ \/ _/ / _ `/ / /|_/ / _ `/  '_/ -_) _/ / / -_)
# /_/|_/_//_\_\    \__/\___/_//_/_//_/\_, / /_/  /_/\_,_/_/\_\\__/_//_/_/\__/
#                                    /___/
#
# Makefile for the PhiNix Nix configuration.
# Shortcuts to switch, boot, test, build, format, update and check the Nix flake.

# Default host to target; falls back to the current short hostname.
HOST ?= $(shell hostname -s)
# Absolute path to the flake (this directory).
FLAKE := $(CURDIR)
# SSH destination of a fresh machine for `make install` (root@ or nixos@).
# Required; e.g. make install HOST=foo TARGET=root@10.0.0.5
TARGET ?=

# Declare targets with no matching file.
.PHONY: switch boot test build install fmt update check

# Rebuild the system and switch to the new configuration (require sudo).
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

# Stage the new configuration for the next boot without activating it; useful
# for kernel/initrd changes. Requires a reboot to take effect (require sudo).
boot:
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)

# Activate the new configuration at runtime without touching the boot entry.
test:
	sudo nixos-rebuild test --flake $(FLAKE)#$(HOST)

# Build the configuration without activating it.
build:
	nixos-rebuild build --flake $(FLAKE)#$(HOST)

# Install NixOS on a fresh machine via nixos-anywhere (wipes its disk).
# Requires SSH access and passwordless sudo (or root) on the target.
install:
	@test -n "$(TARGET)" || { echo "Usage: make install HOST=<host> TARGET=root@<ip>"; exit 1; }
	nix run .#nixos-anywhere -- --flake $(FLAKE)#$(HOST) --target-host $(TARGET)

# Format all .nix files in the repo with Alejandra.
fmt:
	nix fmt .

# Update flake inputs, then format the updated lockfile.
update:
	nix flake update
	nix fmt .

# Validate the whole flake.
check:
	nix flake check
