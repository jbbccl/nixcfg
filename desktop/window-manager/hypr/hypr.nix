{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (builtins.elem "hypr" config.desktop.windowManager) {
	programs.hyprland.enable = true;

	environment.systemPackages = with pkgs; [
		xwayland-satellite
		wl-clipboard
		grim
		slurp
		jq
	];

	home-manager.users.${username} = {
		xdg.configFile = mkConfigDir "hypr" ./config;
	};

	xdg.portal = {
		extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
		config = {
			hyprland = {
				default = [ "hyprland" "gtk" ];
				"org.freedesktop.impl.portal.Screenshot" = "hyprland";
				"org.freedesktop.impl.portal.ScreenCast" = "hyprland";
				"org.freedesktop.impl.portal.FileChooser" = "gtk";
				"org.freedesktop.impl.portal.AppChooser" = "gtk";
				"org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
			};
		};
	};
  };
}
