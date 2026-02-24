{ config, pkgs, ... }:{
	hardware.bluetooth.enable = true;
	hardware.enableRedistributableFirmware = true;
	hardware.graphics = {
		enable = true;
		# 32兼容
		# enable32Bit = true;
		# VAAPI
		extraPackages = with pkgs; [
			intel-media-driver
			# intel-vaapi-driver # 旧
			# amdvlk
			# 其他
			# libvdpau-va-gl
		];
	};
}