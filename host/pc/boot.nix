{
  pkgs,
  ...
}: {
  boot = {
    # 内核随 flake.nix 里 nixpkgs-unstable 的 pin (linux-zen 7.2.11)
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;


    supportedFilesystems = ["ntfs"];
    kernel.sysctl = {
      "kernel.perf_event_paranoid" = 0;
    };
    kernelParams = [
      "quiet"
      "systemd.show_status=0"
      # "fbcon=font:TER10x18"
      "8250.nr_uarts=4"
      # "video=DP-1:1920x1080@120.000"
    ];

    loader = {
      #systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      
      grub = {
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;
        mirroredBoots = [
          {
            path = "/boot";
            devices = ["nodev"];
            efiSysMountPoint = "/boot/efi";
            efiBootloaderId = "NixOS-xfs";
          }
        ];
      };
    };
  };

  fileSystems = {
    "/home/backup" = {
      device = "/dev/disk/by-uuid/BE0C1FAE4B33B9A6";
      fsType = "ntfs";
      options = [
      	"noauto"
      	"x-systemd.automount"
      ];
    };
    "/home/unsafe" = {
      device = "/dev/disk/by-uuid/4C1C7F941C7F7832";
      fsType = "ntfs";
      options = [
      	"noauto"
      	"x-systemd.automount"
      ];
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 17408;
      priority = 0;
    }
  ];
  systemd.tmpfiles.rules = ["d /swap 0755 root root -"];
  zramSwap = {
    enable = true;
    priority = 10;
  };

  # x86_64 不需要 device tree；显式关闭可避免某些内核包
  # （例如 pkgs.stable.linuxPackages_zen）缺少 buildDTBs 时评估失败。
  hardware.deviceTree.enable = false;
}
