{
  config,
  lib,
  pkgs,
  ...
}:
let
	niri-start-script = pkgs.writeShellScriptBin "start" ''
		export XAUTHORITY=$(mktemp /tmp/xauth.XXXXXXXXXX)
		${pkgs.xauth}/bin/xauth generate $DISPLAY .
		${pkgs.niri}/bin/niri-session "$@"
	'';
in {
	config = lib.mkIf (config.desktop.displayManager == "greetd") {
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
