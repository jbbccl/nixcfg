{ config, pkgs, ... }:{
	hardware.bluetooth.enable = true;
	hardware.enableRedistributableFirmware = true;
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver
		];
	};
}