#    _  ___        _____         __        __  _
#   / |/ (_)_ __  / ___/__ ____ / /__ ___ / /_(_)__ _
#  /    / /\ \ / / /__/ _ `/ -_) / -_|_-</ __/ / _ `/
# /_/|_/_//_\_\  \___/\_,_/\__/_/\__/___/\__/_/\_,_/
# ---------------------------------------------------
# Caelestia shell (+ CLI) nix home config by lPhiNix
#
# Wires up the official Home Manager module of the Caelestia shell, enabling
# the desktop shell and its CLI, and seeds ~/.config/caelestia/shell.json once.
#
# shell.json is runtime state: the shell rewrites it with an atomic rename,
# which replaces any symlink. It is therefore never linked, only seeded on
# first activation; from then on the shell UI owns it.
{
  config,
  lib,
  inputs,
  ...
}: {
  # The shell module has to be imported unconditionally (imports are static);
  # the configuration below is what gets gated by the desktop feature.
  imports = [inputs.caelestia-shell.homeManagerModules.default];

  config = lib.mkIf config.features.desktop {
    programs.caelestia = {
      enable = true;

      # The shell is started from the Hyprland config (execs.lua), so the
      # systemd service is disabled. The target is set explicitly to avoid
      # depending on config.wayland.systemd.target.
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };

      # Puts `caelestia` on PATH: required by the Hyprland keybinds and by the
      # dynamic (Material You) theming.
      cli.enable = true;
    };

    # Seed shell.json from the dotfiles repository the first time only. It is
    # deliberately not managed by Home Manager, so the shell UI can rewrite it.
    home.activation.seedCaelestia = lib.hm.dag.entryAfter ["writeBoundary"] ''
      [ -e "$HOME/.config/caelestia/shell.json" ] \
        || $DRY_RUN_CMD install -Dm644 ${inputs.dotfiles}/.config/caelestia/shell.json \
             "$HOME/.config/caelestia/shell.json"
    '';
  };
}
