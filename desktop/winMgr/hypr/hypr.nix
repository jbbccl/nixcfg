{ config, lib, pkgs, username, ... }:
{
  config = lib.mkIf (builtins.elem "hypr" config.desktop.winMgr.list) {
	programs.hyprland.enable = true;
	environment.systemPackages = with pkgs; [
		xwayland-satellite
		wl-clipboard
		grim
		slurp
		jq
	];
	home-manager.users.${username} = {
		xdg.configFile."hypr/" = {
			force = true;
			recursive = true;
			source = ./config;
		};
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
