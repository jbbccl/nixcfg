{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.fileMgr.thunar;
in
{
	options.desktop.fileMgr.thunar.enable = lib.mkEnableOption "thunar file manager";

	config = lib.mkIf cfg.enable {
		programs.thunar.enable = true;
		services.gvfs.enable = true;
		services.tumbler.enable = true;

		home-manager.users.${username} = {
			xdg.configFile."Thunar/uca.xml" = {
				force = true;
				recursive = true;
				source = ./uca.xml;
			};
		};
	};
}
