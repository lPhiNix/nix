#    _  ___        ___          __   __
#   / |/ (_)_ __  / _ \___ ___ / /__/ /____  ___
#  /    / /\ \ / / // / -_|_-</  '_/ __/ _ \/ _ \
# /_/|_/_//_\_\ /____/\__/___/_/\_\\__/\___/ .__/
#                                         /_/
# -----------------------------------------------
# Desktop nix home packages by lPhiNix
#
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Caelestia shell + CLI.
  imports = [inputs.caelestia-shell.homeManagerModules.default];

  programs.caelestia = lib.mkIf config.features.desktop {
    enable = true;
    systemd = {
      enable = false; # The shell is started from the Hyprland config (execs.lua)
      target = "graphical-session.target";
    };
    cli.enable = true; # The CLI (caelestia command) is required by the keybinds and the dynamic theming.
  };

  home.packages = lib.mkIf config.features.desktop (with pkgs; [
    kitty # Terminal

    nautilus # File manager
    brave # Web browser
    pkgs.unstablePkgs.tor-browser # Tor Browser (anonymity)
    pkgs.unstablePkgs.vscode # Code editor (GUI IDE)
    obsidian # Markdown vault
    obs-studio # Screen recording and streaming
    pkgs.unstablePkgs.lmstudio # Local LLM desktop app
    quickemu # Quick VMs (quickget/quickemu CLI)

    libnotify # Desktop notifications
    wl-clipboard # Wayland clipboard
    cliphist # Clipboard history
    hyprpicker # Screen color picker
    ydotool # Input automation (keyboard/mouse)
    gnome-keyring # Secrets & password keyring

    gammastep # Screen color temperature
    pwvucontrol # Per-app volume control

    papirus-icon-theme # Papirus icons
    papirus-folders # Papirus folder color tool
    adwaita-icon-theme # Adwaita (GNOME) icons
    kdePackages.breeze # Cursor Breeze de KDE (breeze_cursors)
    nerd-fonts.jetbrains-mono # JetBrains Mono with Nerd glyphs
  ]);
}
