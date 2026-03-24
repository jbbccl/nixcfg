{ config, pkgs, ... }:{
	boot = {
		# kernelPackages = pkgs.stable.linuxPackages_zen;
		kernelPackages = pkgs.linuxKernel.packages.linux_zen;
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
				#efiInstallAsRemovable = true; # 如果 canTouchEfiVariables不能用
				device = "nodev";
			};
		};
	};


}
