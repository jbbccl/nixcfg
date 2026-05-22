{ config, lib, pkgs, ... }:{
	boot = {
		kernelPackages = pkgs.linuxKernel.packages.linux_zen.extend (kself: ksuper: {
			kernel = ksuper.kernel.override {
				structuredExtraConfig = with lib.kernel; {
					MZEN3 = yes;
					FONT_TER10x18 = yes;
				};
				ignoreConfigErrors = true;
			};
		});

		supportedFilesystems = [ "ntfs" ];
		kernel.sysctl = {
			"kernel.perf_event_paranoid" = 0;
		};
		kernelParams=[
			# "quiet"
			# "systemd.show_status=0"
			"fbcon=font:TER16x32"#16x32"
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
	# swapDevices = [ { device = "/swap/swapfile"; size = 32768; } ];

}
