{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.notif.mako;
in
{
	options.desktop.notif.mako.enable = lib.mkEnableOption "mako notification daemon";

	config = lib.mkIf cfg.enable {
		home-manager.users.${username} = {
			services.mako.enable = true;
			xdg.configFile."mako/" = {
				force = true;
				recursive = true;
				source = ./.;
			};
		};
	};
}
