{ config, lib, pkgs, username, ... }:
{
	options.apps.toolkits.enable = lib.mkEnableOption "toolkits";

	imports = [
		./misc.nix
		./vm-managers.nix
		./wireshark.nix
	];

	config = lib.mkIf config.apps.toolkits.enable {
		environment.sessionVariables = rec {
			PATH = [ "/opt/toolkit/ass/bin" ];
			XDG_DATA_DIRS = [ "/opt/toolkit/ass/" ];
		};
	};
}
