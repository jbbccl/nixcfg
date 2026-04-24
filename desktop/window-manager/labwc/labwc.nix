{ config, lib, pkgs, username, ... }:
{
  config = lib.mkIf (builtins.elem "labwc" config.desktop.windowManager) {
	programs.labwc.enable = true;
	environment.systemPackages = with pkgs; [git
		# labwc
		wlr-randr
		xwayland-satellite
		wl-clipboard
	];

	home-manager.users.${username} = {
		dconf.settings = {
			"org/gnome/desktop/wm/preferences" = {
			button-layout = "appmenu:minimize,maximize,close";
			};
		};
		xdg.configFile = {
			"labwc/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
		home.file = {
		".local/share/themes/" = {
				source = ./themes;
				force = true;
				recursive = true;
			};
		};
	};

	systemd.user.targets.labwc-session = {
		description = "Labwc Compositor Session";
		documentation = [ "man:systemd.special(7)" ];
		bindsTo = [ "graphical-session.target" ];
		wants = [ "graphical-session.target" ];
		after = [ "graphical-session.target" ];
	};

	xdg.portal = {
		extraPortals = with pkgs; [xdg-desktop-portal-wlr];
		config = {
			labwc = {
				default = [ "wlr" "gtk" ];
				"org.freedesktop.impl.portal.Screenshot" = "wlr";
				"org.freedesktop.impl.portal.ScreenCast" = "wlr";
				"org.freedesktop.impl.portal.FileChooser" = "gtk";
				"org.freedesktop.impl.portal.AppChooser" = "gtk";
			};
		};
	};
  };
}
