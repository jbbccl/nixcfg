{ options }:
{ pkgs, username, ... }:
{
	imports = [
		./niri/niri.nix
		./labwc/labwc.nix
		./mangowc/mangowc.nix
	];

	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	environment.systemPackages = with pkgs; [
		xauth
		# xhost

		wl-clipboard
		# xdg-desktop-portal-gnome
		# xdg-desktop-portal-gtk
		polkit_gnome
		seahorse
	];
	environment.sessionVariables.XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
	# xdg
	xdg.portal = {
		enable = true;
		wlr.enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-gnome
		];
	};
	# policy
	security.polkit.enable = true; # polkit
	services.gnome.gnome-keyring.enable = true; # secret service
	security.pam.services.swaylock = {};

	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
			# enable = true;#显示启动
			description = "polkit-gnome-authentication-agent-1";
			# labwc 不能触发target
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};
}
