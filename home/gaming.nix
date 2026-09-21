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
  features,
  ...
}: {
  config = lib.mkIf features.gaming {
    home.packages = with pkgs; [
      # osu! launcher: isolate game data in ~/.games and clear LD_LIBRARY_PATH to avoid clashes.
      (writeShellScriptBin "osu" ''
        unset LD_LIBRARY_PATH
        export XDG_DATA_HOME="$HOME/.games/osu/data"
        mkdir -p "$XDG_DATA_HOME"
        exec ${pkgs.unstablePkgs.osu-lazer-bin}/bin/osu! "$@"
      '')
    ];
    # Desktop entry so the launcher shows up in the app menu.
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
