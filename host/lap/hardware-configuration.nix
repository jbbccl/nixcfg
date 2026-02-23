{ config, lib, pkgs, modulesPath, ... }:

{
	imports =[ 
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
	boot.initrd.kernelModules = [ ];
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [ ];

	fileSystems = {
		"boot/efi" = {
			device = "/dev/disk/by-uuid/FED5-34ED";
			fsType = "vfat";
			options = [
				"umask=0077"
				"fmask=0022"
				"dmask=0022"
			];
		};
		"/" = {
			device = "/dev/disk/by-uuid/ea5a05c7-0aac-4a8f-9544-88bf8ba2fa33";
			fsType = "btrfs";
			options = [
				"compress=zstd"
				"noatime"
				"subvol=@nixos"
			];
		};
	};

	swapDevices = [ 
		{ device = "/dev/disk/by-uuid/6704876b-7057-44c4-8fa4-9bbfe71ed810"; }
	];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}