{ config, lib, pkgs, ... }:
let
cfg = config.desktop.dispMgr.greetd;
wayland-session = config.services.displayManager.sessionData.desktops;
xsession = config.services.displayManager.sessionData.desktops;
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
					--sessions ${wayland-session}/share/wayland-sessions:${xsession}/share/xsessions \
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
