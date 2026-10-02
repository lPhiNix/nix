#    _  ___        _____         __        __  _
#   / |/ (_)_ __  / ___/__ ____ / /__ ___ / /_(_)__ _
#  /    / /\ \ / / /__/ _ `/ -_) / -_|_-</ __/ / _ `/
# /_/|_/_//_\_\  \___/\_,_/\__/_/\__/___/\__/_/\_,_/
# ---------------------------------------------------
# Caelestia shell (+ CLI) nix home config by lPhiNix
#
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

      # Puts 'caelestia' on PATH: required by the Hyprland keybinds and by the
      # dynamic (Material You) theming.
      cli.enable = true;
    };
  };
}
