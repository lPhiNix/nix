#  _   _       _        ____  _     _
# | \ | | ___ (_)_ __  |  _ \(_)___| | _____
# |  \| |/ _ \| | '__| | | | | / __| |/ / _ \
# | |\  | (_) | | |    | |_| | \__ \   < (_) |
# |_| \_|\___/|_|_|    |____/|_|___/_|\_\___/
# --------------------------------------------
# Noir disko nix configuration by lPhiNix
#
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00BH1_S63ZNX1TC88541";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          name = "ESP";
          size = "1G";
          type = "EF00";
          uuid = "fe40bfb3-2066-44c7-8279-977b40d5f098";
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
          uuid = "344d0178-045b-421c-91f6-3785ff69049a";
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
