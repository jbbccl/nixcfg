{ pkgs, username, ... }:
{
	programs.niri.enable = true;

	# environment.sessionVariables.NIXOS_OZONE_WL = "1";
	home-manager.users.${username} = {
		xdg.configFile = {
			"niri/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		# xauth
		# # xhost
		# # labwc

		# # xdg-desktop-portal-gnome
		# # xdg-desktop-portal-gtk
		# polkit_gnome
		# seahorse

		# wl-clipboard
	];
	# environment.sessionVariables.XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

	# xdg.portal = {
	# 	enable = true;
	# 	wlr.enable = true;
	# 	extraPortals = with pkgs; [
	# 		xdg-desktop-portal-gtk
	# 		xdg-desktop-portal-gnome
	# 	];
	# };

	# security.polkit.enable = true; # polkit
	# services.gnome.gnome-keyring.enable = true; # secret service
	# security.pam.services.swaylock = {};
	# systemd = {
	# 	user.services.polkit-gnome-authentication-agent-1 = {
	# 		description = "polkit-gnome-authentication-agent-1";
	# 		wantedBy = [ "graphical-session.target" ];
	# 		wants = [ "graphical-session.target" ];
	# 		after = [ "graphical-session.target" ];
	# 		serviceConfig = {
	# 			Type = "simple";
	# 			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
	# 			Restart = "on-failure";
	# 			RestartSec = 1;
	# 			TimeoutStopSec = 10;
	# 		};
	# 	};
	# };
}
