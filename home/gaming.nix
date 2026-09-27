#    _  ___        _____           _
#   / |/ (_)_ __  / ___/__ ___ _  (_)__  ___ _
#  /    / /\ \ / / (_ / _ `/  ' \/ / _ \/ _ `/
# /_/|_/_//_\_\  \___/\_,_/_/_/_/_/_//_/\_, /
#                                      /___/
# --------------------------------------------
# Gaming nix home packages by lPhiNix
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.features.gaming {
    home.packages = with pkgs; [
      # ATLauncher: isolate its data under ~/.games instead of ~/.local/share.
      (writeShellScriptBin "atlauncher" ''
        export XDG_DATA_HOME="$HOME/.games"
        mkdir -p "$XDG_DATA_HOME"
        exec ${pkgs.atlauncher-bin}/bin/atlauncher "$@"
      '')

      # osu! launcher: isolate game data in ~/.games and clear LD_LIBRARY_PATH to avoid clashes.
      (writeShellScriptBin "osu" ''
        unset LD_LIBRARY_PATH
        export XDG_DATA_HOME="$HOME/.games/osu/data"
        mkdir -p "$XDG_DATA_HOME"
        exec ${pkgs.unstablePkgs.osu-lazer-bin}/bin/osu! "$@"
      '')
    ];
    # Desktop entries so the launchers show up in the app menu.
    xdg.desktopEntries."atlauncher" = {
      name = "ATLauncher";
      comment = "A launcher for Minecraft which integrates multiple different modpacks to allow you to download and install modpacks easily and quickly.";
      exec = "${config.home.profileDirectory}/bin/atlauncher";
      icon = "${pkgs.atlauncher-bin}/share/icons/hicolor/128x128/apps/atlauncher.png";
      terminal = false;
      categories = ["Game"];
      settings = {
        Keywords = "game;Minecraft;";
        StartupWMClass = "com-atlauncher-App";
        StartupNotify = "true";
      };
    };
    xdg.desktopEntries."osu" = {
      name = "osu!";
      comment = "Rhythm is just a *click* away";
      exec = "${config.home.profileDirectory}/bin/osu";
      icon = "${pkgs.unstablePkgs.osu-lazer-bin}/share/icons/hicolor/512x512/apps/osu.png";
      terminal = false;
      categories = ["Game"];
      settings.StartupWMClass = "osu!";
    };
  };
}
