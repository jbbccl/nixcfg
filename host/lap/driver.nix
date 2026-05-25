{ config, pkgs, ... }:{
	hardware.enableRedistributableFirmware = true;
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver
		];
	};
}