#  _   _ _         ___        _   _
# | \ | (_)_  __  / _ \ _ __ | |_(_) ___  _ __  ___
# |  \| | \ \/ / | | | | '_ \| __| |/ _ \| '_ \/ __|
# | |\  | |>  <  | |_| | |_) | |_| | (_) | | | \__ \
# |_| \_|_/_/\_\  \___/| .__/ \__|_|\___/|_| |_|___/
#                      |_|
# --------------------------------------------------
# Nix options module by lPhiNix
#
# Declares the shared myConfig option namespace: the per-host data that every
# machine provides. modules/default.nix then translates those values into real
# system configuration.
#
{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.myConfig = {
    # Machine identity: also the attribute name under nixosConfigurations.
    hostName = mkOption {
      type = types.str;
      description = "Hostname (also the attribute name in nixosConfigurations).";
    };

    # Primary user account.
    username = mkOption {
      type = types.str;
      default = "phinix";
      description = "Primary system user.";
    };

    # Extra groups added to the primary user's account.
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra groups for the primary user.";
    };

    # System timezone.
    timezone = mkOption {
      type = types.str;
      default = "Europe/Madrid";
    };

    # TTY console keymap (the graphical session is configured elsewhere).
    consoleKeyMap = mkOption {
      type = types.str;
      default = "us";
      description = "TTY keymap (does not affect Hyprland).";
    };

    # Machine profiles: each profile enables sensible defaults for that kind of host.
    profiles = mkOption {
      type = types.listOf (types.enum ["laptop" "desktop" "server"]);
      default = [];
      description = "Machine profiles; each profile enables sensible defaults.";
    };

    # GPU selection and optional PRIME offload.
    gpu = {
      # Primary GPU vendor; null disables all GPU configuration.
      provider = mkOption {
        type = types.nullOr (types.enum ["intel" "amd" "nvidia"]);
        default = null;
        description = "Primary GPU, or null to disable GPU configuration.";
      };

      # PRIME offload, used by hybrid laptops.
      prime = {
        # Enable PRIME offload.
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "PRIME offload (hybrid laptops).";
        };

        # PCI BusID of the NVIDIA GPU.
        nvidiaBusId = mkOption {
          type = types.str;
          default = "";
        };

        # PCI BusID of the integrated GPU.
        intelBusId = mkOption {
          type = types.str;
          default = "";
        };
      };
    };
  };
}
