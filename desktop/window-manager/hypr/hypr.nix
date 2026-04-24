{ config, lib, pkgs, ... }: {
  config = lib.mkIf (builtins.elem "hypr" config.desktop.windowManager) {
	programs.hyprland.enable = true;

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
