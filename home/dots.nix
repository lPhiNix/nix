#  _   _ _        ____        _    __ _ _
# | \ | (_)_  __ |  _ \  ___ | |_ / _(_) | ___  ___
# |  \| | \ \/ / | | | |/ _ \| __| |_| | |/ _ \/ __|
# | |\  | |>  <  | |_| | (_) | |_|  _| | |  __/\__ \
# |_| \_|_/_/\_\ |____/ \___/ \__|_| |_|_|\___||___/
# --------------------------------------------------
# Dots home module by lPhiNix
#
# Deploys the dotfiles repository into the home directory. The repository is a
# flake input (flake = false), fetched over HTTPS and pinned in flake.lock. It
# contains only static, tracked files, so whole directories can be linked
# recursively.
#
{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) optionalAttrs;

  # Source tree of the dotfiles repository (see flake.nix).
  dotfiles = inputs.dotfiles.outPath;

  # --- config: always deployed ---------------------------------------------
  base = {
    "fish" = {
      source = "${dotfiles}/.config/fish";
      recursive = true;
    };
    "btop" = {
      source = "${dotfiles}/.config/btop";
      recursive = true;
    };
    "fastfetch" = {
      source = "${dotfiles}/.config/fastfetch";
      recursive = true;
    };
    "Code" = {
      source = "${dotfiles}/.config/Code";
      recursive = true;
    };
    "nvim" = {
      source = "${dotfiles}/.config/nvim";
      recursive = true;
    };
    "starship.toml" = {
      source = "${dotfiles}/.config/starship.toml";
    };
    "code-flags.conf" = {
      source = "${dotfiles}/.config/code-flags.conf";
    };
  };

  # --- config: desktop only -------------------------------------------------
  desktop = {
    "hypr" = {
      source = "${dotfiles}/.config/hypr";
      recursive = true;
    };
    "kitty" = {
      source = "${dotfiles}/.config/kitty";
      recursive = true;
    };
    "caelestia/hypr-user.lua" = {
      source = "${dotfiles}/.config/caelestia/hypr-user.lua";
    };
    "caelestia/hypr-vars.lua" = {
      source = "${dotfiles}/.config/caelestia/hypr-vars.lua";
    };
    "caelestia/user-config.fish" = {
      source = "${dotfiles}/.config/caelestia/user-config.fish";
    };
    "caelestia/cli.json" = {
      source = "${dotfiles}/.config/caelestia/cli.json";
    };
  };
in {
  xdg.configFile = base // optionalAttrs config.features.desktop desktop;

  home.file = optionalAttrs config.features.desktop {
    "Pictures/Wallpapers/noir.jpg" = {
      source = "${dotfiles}/Pictures/Wallpapers/noir.jpg";
    };
    "Pictures/Screenshots/noir.png" = {
      source = "${dotfiles}/Pictures/Screenshots/noir.png";
    };
  };
}
