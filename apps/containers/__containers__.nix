{ config, lib, ... }: {
	options.apps.containers = {
		debian.enable = lib.mkEnableOption "Debian daily container";
		kali.enable = lib.mkEnableOption "Kali daily container";
	};
	imports = [
		./debian
		# ./kali
	];
	config = lib.mkIf config.apps.containers.enable {
		apps.containers.debian.enable = lib.mkDefault true;
		apps.containers.kali.enable = lib.mkDefault true;
	};
}
