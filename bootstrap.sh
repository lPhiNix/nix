#!/usr/bin/env bash
#    _  ___        ___            __      __
#   / |/ (_)_ __  / _ )___  ___  / /____ / /________ ____
#  /    / /\ \ / / _  / _ \/ _ \/ __(_-</ __/ __/ _ `/ _ \
# /_/|_/_//_\_\ /____/\___/\___/\__/___/\__/_/  \_,_/ .__/
#                                                  /_/
#
# PhiNix Nix system bootstrap
#
#   curl -fsSL https://raw.githubusercontent.com/lPhiNix/nix/main/bootstrap.sh | bash
#
# Clones this flake into ~/.nix (only if missing) and applies it:
#
#   - NixOS        -> nixos-rebuild switch --flake ~/.nix#<host>
#   - other Linux  -> home-manager switch --flake ~/.nix#standalone-<arch>
#
# The machine must already be installed: this never touches disks (no
# partitioning). The host defaults to `hostname -s`. Repos are public but
# cloned over SSH, so a working GitHub SSH key is required.

set -euo pipefail

REPO="git@github.com:lPhiNix/nix.git"
NIX_DIR="$HOME/.nix"
HOST="$(hostname -s)"
NIX=(nix --extra-experimental-features "nix-command flakes")

echo ">> Host: $HOST"

# --- preflight -------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "!! 'git' is missing."; exit 1; }

if ! git ls-remote "$REPO" HEAD >/dev/null 2>&1; then
  echo "!! Cannot reach $REPO over SSH."
  echo "   Set up your GitHub SSH key (the repos are public, but they are"
  echo "   cloned over SSH) and try again."
  exit 1
fi

# Outside NixOS, Nix must already be installed. We warn, we do not install it.
if [ ! -e /etc/NIXOS ] && ! command -v nix >/dev/null 2>&1; then
  echo "!! Nix is not installed. Install it and run this script again:"
  echo "   sh <(curl -fsSL https://nixos.org/nix/install) --daemon"
  exit 1
fi

# --- clone (only if missing) -----------------------------------------------
if [ ! -e "$NIX_DIR/.git" ]; then
  echo ">> Cloning $REPO"
  git clone "$REPO" "$NIX_DIR"
fi

# --- apply -----------------------------------------------------------------
if [ -e /etc/NIXOS ]; then
  hosts="$("${NIX[@]}" eval --json "$NIX_DIR#nixosConfigurations" --apply 'builtins.attrNames' 2>/dev/null || echo '[]')"
  if ! printf '%s' "$hosts" | grep -q "\"$HOST\""; then
    echo "!! Host '$HOST' is not in nixosConfigurations. Available: $hosts"
    exit 1
  fi
  sudo nixos-rebuild switch --flake "$NIX_DIR#$HOST"
else
  case "$(uname -m)" in
    x86_64) system="x86_64-linux" ;;
    aarch64 | arm64) system="aarch64-linux" ;;
    *)
      echo "!! Unsupported architecture: $(uname -m)."
      exit 1
      ;;
  esac
  target="standalone-$system"
  cfgs="$("${NIX[@]}" eval --json "$NIX_DIR#homeConfigurations" --apply 'builtins.attrNames' 2>/dev/null || echo '[]')"
  if ! printf '%s' "$cfgs" | grep -q "\"$target\""; then
    echo "!! homeConfigurations.\"$target\" does not exist. Available: $cfgs"
    exit 1
  fi
  "${NIX[@]}" run github:nix-community/home-manager/release-26.05 -- \
    switch --flake "$NIX_DIR#$target"
fi

echo ">> Done."
