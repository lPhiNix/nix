#    _  ___                        ____        __  ___     __       ____ __
#   / |/ (_)_ _____________  ___  / _(_)__ _  /  |/  /__ _/ /_____ / _(_) /__
#  /    / /\ \ /___/ __/ _ \/ _ \/ _/ / _ `/ / /|_/ / _ `/  '_/ -_) _/ / / -_)
# /_/|_/_//_\_\    \__/\___/_//_/_//_/\_, / /_/  /_/\_,_/_/\_\\__/_//_/_/\__/
#                                    /___/
#
# Makefile for the PhiNix Nix configuration.
# Shortcuts to switch, build, format, update and check the Nix flake.

# Default host to target; falls back to the current short hostname.
HOST ?= $(shell hostname -s)
# Absolute path to the flake (this directory).
FLAKE := $(CURDIR)

# Declare targets with no matching file.
.PHONY: switch build fmt update check

# Rebuild the system and switch to the new configuration (require sudo).
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

# Build the configuration without activating it.
build:
	nixos-rebuild build --flake $(FLAKE)#$(HOST)

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
