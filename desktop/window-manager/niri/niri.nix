{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (builtins.elem "niri" config.desktop.windowManager) {
	programs.niri.enable = true;

	home-manager.users.${username} = {
		xdg.configFile = mkConfigDir "niri" ./config;
	};

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		wl-clipboard
	];

	xdg.portal = {
		extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
		config.niri = {
			default = [ "gnome" "gtk" ];
			"org.freedesktop.impl.portal.FileChooser" = "gtk";
			"org.freedesktop.impl.portal.AppChooser" = "gtk";
		};
	};
  };
}
