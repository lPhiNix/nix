#     _   ___         __  ___          __      __
#    / | / (_)  __   /  |/  /___  ____/ /_  __/ /__  _____
#   /  |/ / / |/_/  / /|_/ / __ \/ __  / / / / / _ \/ ___/
#  / /|  / />  <   / /  / / /_/ / /_/ / /_/ / /  __(__  )
# /_/ |_/_/_/|_|  /_/  /_/\____/\__,_/\__,_/_/\___/____/
# --------------------------------------------------------
# Nix modules configuration by lPhiNix
#
# Aggregates every shared system module and translates the per-host myConfig
# values into real system configuration. It is the entry point imported for
# every host.
#
{config, ...}: {
  imports = [
    # Modules: shared, reusable system modules.
    ./options.nix
    ./core.nix
    ./graphics.nix
    ./audio.nix
    ./network.nix
    ./desktop.nix
    ./gaming.nix
    ./power.nix
    ./shell.nix
    ./users.nix

    # Profiles: per-machine-type defaults for the features above.
    ./profiles/laptop.nix
    ./profiles/desktop.nix
    ./profiles/server.nix
  ];

  networking.hostName = config.myConfig.hostName;
}
