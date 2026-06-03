{ config, lib, pkgs, ... }:
let
	cfg = config.desktop.dispMgr.greetd;
	sessionData = config.services.displayManager.sessionData.desktops;
in
{
	options.desktop.dispMgr.greetd.enable = lib.mkEnableOption "greetd";

	config = lib.mkIf cfg.enable {
		services.greetd = {
			enable = true;
			useTextGreeter = true;
			settings = {
				default_session = {
					command = lib.concatStringsSep " " [
                        "${lib.getExe pkgs.tuigreet}"
                        "--sessions ${sessionData}/share/wayland-sessions:${sessionData}/share/xsessions"
                        "--time"
                        "--time-format '%Y-%m-%d %H:%M'"
                        "--asterisks"
                        "--remember"
                        "--remember-session"
                    ];
				};
			};
		};
	};
}
