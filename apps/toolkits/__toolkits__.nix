{ config, lib, pkgs, username, ... }:
{
	options.apps.toolkits.enable = lib.mkEnableOption "toolkits";

	imports = [
		./misc.nix
		./editors.nix
		./vm-managers.nix
		./wireshark.nix
        ./8091.nix
	];

	config = lib.mkIf config.apps.toolkits.enable {
		environment.sessionVariables = rec {
			PATH = [ "/opt/toolkit/ass/bin" ];
			XDG_DATA_DIRS = [ "/opt/toolkit/ass/" ];
		};
	};
}
