{ config, pkgs, ... }:{
	boot = {
		# kernelPackages = pkgs.stable.linuxPackages_zen;
		kernelPackages = pkgs.linuxKernel.packages.linux_zen;
		# kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
		supportedFilesystems = [ "ntfs" ];
		kernel.sysctl = {
			"kernel.perf_event_paranoid" = 0;
		};
		kernelParams=[

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
				device = "nodev";
			};
		};
	};

	fileSystems = {
		"/home/VMS" = {
			device = "/dev/disk/by-uuid/097135e3-2cfd-4630-9157-221aff11102a";
			fsType = "btrfs";
			options = [
				"compress=zstd"
				"noatime"
				"subvol=dockers"
			];
		};
		"/home/backup" = {
			device = "/dev/disk/by-uuid/BE0C1FAE4B33B9A6";
			fsType = "ntfs";
		};
	};
	# swapDevices = [ { device = "/swap/swapfile"; size = 32768; } ];

}
