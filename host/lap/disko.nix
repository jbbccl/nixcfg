{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
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
              mountOptions = [ "umask=0077" ];
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
                "@VM" = {
                  mountpoint = "/home/unsafe";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
    # Additional data disk (separate physical drive)
    # disk.vmdata = {
    #   type = "disk";
    #   device = "/dev/sda";  # adjust
    #   content = {
    #     type = "gpt";
    #     partitions.data = {
    #       size = "100%";
    #       content = {
    #         type = "filesystem";
    #         format = "xfs";
    #         mountpoint = "/home/VMS";
    #         mountOptions = [ "noatime" ];
    #       };
    #     };
    #   };
    # };
  };
}
