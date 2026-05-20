{ config, lib, ... }:
{
	options.apps.services.proxy.enable = lib.mkEnableOption "proxy service (mihomo)";

	imports = [
		./mihomo/__mihomo__.nix
	];
}
