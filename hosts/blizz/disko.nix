#  ____  _ _               _ _     _
# | __ )| (_)________   __| (_)___| | _____
# |  _ \| | |_  /_  /  / _` | / __| |/ / _ \
# | |_) | | |/ / / /  | (_| | \__ \   < (_) |
# |____/|_|_/___/___|  \__,_|_|___/_|\_\___/
# --------------------------------------------
# Blizz disko nix configuration by lPhiNix
#
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S7HDNL0L113548P";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          name = "ESP";
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["fmask=0022" "dmask=0022"];
          };
        };
        luks = {
          name = "luks";
          size = "100%";
          content = {
            type = "luks";
            name = "main";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
                };
              };
            };
          };
        };
      };
    };
  };
}
