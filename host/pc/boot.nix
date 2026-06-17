{ config, lib, pkgs, ... }:{
	boot = {
		# kernelPackages = pkgs.linuxPackages_zen_custom;
		kernelPackages = pkgs.linuxKernel.packagesFor (
			pkgs.linuxKernel.kernels.linux_zen.override {
				argsOverride = {
					structuredExtraConfig = pkgs.linuxKernel.kernels.linux_zen.structuredExtraConfig // {
						X86_NATIVE_CPU = lib.kernel.yes;
						FONT_TER10x18 = lib.kernel.yes;
						FONT_TER16x32 = lib.mkForce lib.kernel.no;
					};
				};
				ignoreConfigErrors = true;
			}
		);

		supportedFilesystems = [ "ntfs" ];
		kernel.sysctl = {
			"kernel.perf_event_paranoid" = 0;
		};
		kernelParams=[
			# "quiet"
			# "systemd.show_status=0"
            "fbcon=font:TER10x18"
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
			# options = [
			# 	"noauto"
			# 	"x-systemd.automount"
			# ];
		};
		"/home/unsafe" = {
			device = "/dev/disk/by-uuid/4C1C7F941C7F7832";
			fsType = "ntfs";
			# options = [
			# 	"noauto"
			# 	"x-systemd.automount"
			# ];
		};
	};
	swapDevices = [ { device = "/swap/swapfile"; size = 32768; priority = 0; } ];
	systemd.tmpfiles.rules = [ "d /swap 0755 root root -" ];
	zramSwap = {
		enable = true;
		priority = 10;
	};

}
