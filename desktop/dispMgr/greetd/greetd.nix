{ config, lib, pkgs, ... }:
let
wayland-session = config.services.displayManager.sessionData.desktops;
xsession = config.services.displayManager.sessionData.desktops;
in
{
	config = lib.mkIf (config.desktop.dispMgr.select == "greetd") {
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
