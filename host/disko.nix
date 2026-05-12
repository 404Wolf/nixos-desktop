# Disko layout for wolf-desktop — /dev/sda
# Partition table: GPT
#   427M  ESP  — EFI System Partition (/boot, vfat)  [sda1]
#   rest  root — ext4 root filesystem                [sda2]
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        content = {
          type = "gpt";

          partitions = {
            ESP = {
              size = "427M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
