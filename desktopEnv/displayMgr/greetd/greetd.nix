{
  lib,
  pkgs,
  config,
  ...
}: 
let
	niri-start-script = pkgs.writeShellScriptBin "start" ''
		export XAUTHORITY=$(mktemp /tmp/xauth.XXXXXXXXXX)
		${pkgs.xauth}/bin/xauth generate $DISPLAY .
		${pkgs.niri}/bin/niri-session "$@"
	'';
	# --cmd ${lib.getExe  niri-start-script} ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions
	# --cmd dbus-run-session labwc 
in {
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
}

