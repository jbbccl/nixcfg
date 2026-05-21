{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.winMgr.hypr;
in
{
	options.desktop.winMgr.hypr.enable = lib.mkEnableOption "hyprland window manager";

	config = lib.mkIf cfg.enable {
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
