# Disko layout for wolf-laptop — 1TB NVMe SSD (/dev/nvme0n1)
# Partition table: GPT
#   1M   biosboot  — BIOS boot partition (GRUB legacy fallback)
#   768M ESP       — EFI System Partition (/boot, vfat)
#   rest luks      — LUKS2-encrypted BTRFS (leaves 64G at end for swap)
#   64G  swap      — plain swap partition with hibernate resume
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";

          partitions = {
            biosboot = {
              size = "1M";
              type = "EF02"; # BIOS Boot Partition for GRUB (BIOS mode fallback)
            };

            ESP = {
              size = "768M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            luks = {
              name = "luks";
              end = "-32G"; # leave 32G at the end for the swap partition
              content = {
                type = "luks";
                name = "crypted";
                passwordFile = "/tmp/secret.key";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["noatime"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/var" = {
                      mountpoint = "/var";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/.snapshots" = {};
                  };
                };
              };
            };

            swap = {
              size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
                discardPolicy = "both";
              };
            };
          };
        };
      };
    };
  };
}
