{ config, lib, ... }:
let
	cfg = config.modules.virtual.container.waydroid;
in
{
	options.modules.virtual.container.waydroid.enable = lib.mkEnableOption "waydroid (Android container)";

	config = lib.mkIf cfg.enable {
		virtualisation.waydroid.enable = true;

		networking.firewall.trustedInterfaces = [ "waydroid0" ];
	};
}
