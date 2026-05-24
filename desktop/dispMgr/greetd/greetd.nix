{ config, lib, pkgs, ... }:
let
cfg = config.desktop.dispMgr.greetd;
session = config.services.displayManager.sessionData.desktops;
in
{
    options.desktop.dispMgr.greetd.enable = lib.mkEnableOption "greetd";

	config =  lib.mkIf cfg.enable {
		services.greetd = {
			enable = true;
			useTextGreeter = true;
			settings = {
				default_session = {
					command = ''
					${lib.getExe pkgs.tuigreet} \
					--sessions ${session}/share/wayland-sessions:${session}/share/xsessions \
					--time \
					--time-format '%Y-%m-%d %H:%M' \
					--asterisks \
					--remember \
					--remember-session
					'';
				};
			};
		};
	};
}
