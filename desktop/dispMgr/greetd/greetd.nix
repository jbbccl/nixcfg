{ config, lib, pkgs, ... }:
let
	cfg = config.desktop.dispMgr.greetd;
	uwsmCompositors = lib.attrNames config.programs.uwsm.waylandCompositors;
	sessionData = config.services.displayManager.sessionData.desktops;
	uwsmSessions = pkgs.runCommand "uwsm-sessions" {} (''
		mkdir -p $out/share/wayland-sessions $out/share/xsessions
	''
	+ lib.concatMapStrings (name: ''
		if [ -f ${sessionData}/share/wayland-sessions/${name}.desktop ]; then
			cp ${sessionData}/share/wayland-sessions/${name}.desktop $out/share/wayland-sessions/
		fi
		if [ -f ${sessionData}/share/xsessions/${name}.desktop ]; then
			cp ${sessionData}/share/xsessions/${name}.desktop $out/share/xsessions/
		fi
	'') uwsmCompositors);
in
{
	options.desktop.dispMgr.greetd.enable = lib.mkEnableOption "greetd";

	config = lib.mkIf cfg.enable {
		services.greetd = {
			enable = true;
			useTextGreeter = true;
			settings = {
				default_session = {
					command = ''
					${lib.getExe pkgs.tuigreet} \
					--sessions ${uwsmSessions}/share/wayland-sessions:${uwsmSessions}/share/xsessions \
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
