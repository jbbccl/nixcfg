{ config, lib, pkgs, username, ... }:
{
  config = lib.mkIf (config.desktop.windowManager == "niri") {
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
		# niri
		xwayland-satellite
		wl-clipboard
	];

	# portal
	xdg.portal = {
		extraPortals = with pkgs; [xdg-desktop-portal-gnome];

		config = {
			niri = {
				default = [ "gnome" "gtk" ];
				"org.freedesktop.impl.portal.Screenshot" = "gnome";
				"org.freedesktop.impl.portal.ScreenCast" = "gnome";
				"org.freedesktop.impl.portal.FileChooser" = "gtk";
				"org.freedesktop.impl.portal.AppChooser" = "gtk";
				"org.freedesktop.impl.portal.Inhibit" = "gnome";
				"org.freedesktop.impl.portal.Access" = "gtk";
			};
		};
	};
  };
}
