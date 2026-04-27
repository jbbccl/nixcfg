{
  # disko config for desktop — nix run github:nix-community/disko
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";  # adjust to your NVMe device
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [ "fmask=0022" "dmask=0022" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@nixos" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "@dockers" = {
                  mountpoint = "/home/VMS";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
    # Additional data disk (separate physical drive, NTFS)
    # disk.backup = {
    #   type = "disk";
    #   device = "/dev/sda";  # adjust
    #   content = {
    #     type = "gpt";
    #     partitions.data = {
    #       size = "100%";
    #       content = {
    #         type = "filesystem";
    #         format = "ntfs";
    #         mountpoint = "/home/backup";
    #       };
    #     };
    #   };
    # };
  };
}
