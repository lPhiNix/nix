#!/usr/bin/env bash
#    ___  __   _        ___            __      __
#   / _ \/ /  (_)_ __  / _ )___  ___  / /____ / /________ ____
#  / ___/ _ \/ /\ \ / / _  / _ \/ _ \/ __(_-</ __/ __/ _ `/ _ \
# /_/  /_//_/_//_\_\ /____/\___/\___/\__/___/\__/_/  \_,_/ .__/
#                                                       /_/
#
# Phix system bootstrap
#
#   curl -fsSL https://raw.githubusercontent.com/lPhiNix/phix/main/bootstrap.sh | bash
#
# Applies this flake on an already-installed machine (it never touches disks):
#
#   - NixOS        -> nixos-rebuild switch --flake ~/.phix#<host>
#   - other Linux  -> home-manager switch --flake ~/.phix#standalone
#
# The host defaults to 'hostname -s'. The repo is private and cloned over SSH,
# so a working GitHub SSH key is required. NixOS hosts use sops-nix: if the
# host's age key is not yet at /var/lib/sops-nix/key.txt, set PHIX_AGE_KEY to
# its path to inject it, or the script explains what to do and stops.

set -euo pipefail

REPO="git@github.com:lPhiNix/phix.git"
NIX_DIR="$HOME/.phix"
HOST="$(hostname -s)"
NIX=(nix --extra-experimental-features "nix-command flakes")

echo ">> Host: $HOST"

# --- preflight -------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "!! 'git' is missing."; exit 1; }

if ! git ls-remote "$REPO" HEAD >/dev/null 2>&1; then
  echo "!! Cannot reach $REPO over SSH."
  echo "   Set up your GitHub SSH key (a resident YubiKey key via 'ssh-keygen -K',"
  echo "   or a normal key) and try again."
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

  # sops-nix needs the host's age key to decrypt its secrets. The key is not in
  # the repo; inject it once (make install does this automatically).
  if [ -e "$NIX_DIR/hosts/$HOST/secrets.yaml" ] && [ ! -e /var/lib/sops-nix/key.txt ]; then
    if [ -n "${PHIX_AGE_KEY:-}" ] && [ -e "$PHIX_AGE_KEY" ]; then
      echo ">> Installing host age key from PHIX_AGE_KEY"
      sudo install -D -m600 "$PHIX_AGE_KEY" /var/lib/sops-nix/key.txt
    else
      echo "!! '$HOST' uses sops-nix but /var/lib/sops-nix/key.txt is missing."
      echo "   This key decrypts hosts/$HOST/secrets.yaml and is not in the repo."
      echo "   Options:"
      echo "     - Fresh machine: provision it with 'make install' (injects the key)."
      echo "     - Existing machine: copy it once, e.g."
      echo "         sudo install -D -m600 /path/to/key.txt /var/lib/sops-nix/key.txt"
      echo "       or re-run with: PHIX_AGE_KEY=/path/to/key.txt"
      exit 1
    fi
  fi

  sudo nixos-rebuild switch --flake "$NIX_DIR#$HOST"
else
  case "$(uname -m)" in
    x86_64) ;;
    *)
      echo "!! Unsupported architecture: $(uname -m). Only x86_64-linux is supported."
      exit 1
      ;;
  esac
  target="standalone"
  cfgs="$("${NIX[@]}" eval --json "$NIX_DIR#homeConfigurations" --apply 'builtins.attrNames' 2>/dev/null || echo '[]')"
  if ! printf '%s' "$cfgs" | grep -q "\"$target\""; then
    echo "!! homeConfigurations.\"$target\" does not exist. Available: $cfgs"
    exit 1
  fi
  "${NIX[@]}" run github:nix-community/home-manager/release-26.05 -- \
    switch --flake "$NIX_DIR#$target"
fi

echo ">> Done."
