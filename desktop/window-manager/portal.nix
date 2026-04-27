{ config, lib, pkgs, ... }: {
	# Portal base: only GTK as universal fallback.
	# WM-specific portals (wlr, gnome, hyprland) are added by each WM module.
	# Useless without a WM — gate behind mkIf.
	config = lib.mkIf (lib.length (config.desktop.windowManager or []) > 0) {
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
		};
	};
}
