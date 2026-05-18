{ config, lib, pkgs, ... }:{
	config = lib.mkIf (config.desktop.dispMgr.select == "greetd") {
		services.greetd = {
			enable = true;
			settings = {
				default_session = {
					command = ''
					${lib.getExe pkgs.tuigreet} \
					--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions \
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
