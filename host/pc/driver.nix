{ config, pkgs, ... }:{
	hardware.bluetooth.enable = true;
	hardware.enableRedistributableFirmware = true;
	hardware.graphics = {
		enable = true;
		# enable32Bit = true;
		extraPackages = with pkgs; [
			#amdvlk
		];
	};
}