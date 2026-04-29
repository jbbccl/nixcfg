{ config, lib, ... }: {
	imports = [
		./debian
		./kali
	];
	config = lib.mkIf config.apps.containers.enable {
		apps.containers.debian.enable = lib.mkDefault true;
		apps.containers.kali.enable = lib.mkDefault true;
	};
}
