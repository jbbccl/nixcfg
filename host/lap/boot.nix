{ config, pkgs, ... }:{
	boot = {
		# kernelPackages = pkgs.stable.linuxPackages_zen;
		kernelPackages = pkgs.linuxKernel.packages.linux_zen;
		supportedFilesystems = [ "ntfs" ];
		kernel.sysctl = {
			"kernel.perf_event_paranoid" = 0;
		};
		kernelParams=[
			"intel_iommu=on"
			"iommu=pt"
			"i915.force_probe=!a7a0"
			"xe.force_probe=a7a0"
		];

		loader = {
			systemd-boot.enable = true;
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot/efi";
			};
			# grub = {
			# 	efiSupport = true;
			# 	#efiInstallAsRemovable = true; # 如果 canTouchEfiVariables不能用
			# 	device = "nodev";
			# };
		};
	};

	fileSystems = {
		"/home/unsafe" = {
			device = "/dev/disk/by-uuid/ea5a05c7-0aac-4a8f-9544-88bf8ba2fa33";
			fsType = "btrfs";
			options = [
				"compress=zstd"
				"noatime"
				"subvol=@VM"
			];
		};
		"/home/VMS" = {
			device = "/dev/disk/by-uuid/a2a06942-a7ba-40a6-acf9-c2811caff238";
			fsType = "xfs";
			options = [
				"noatime"
			];
		};
	};
}