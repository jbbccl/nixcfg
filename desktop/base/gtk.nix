{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.base.gtk;
in
{
	options.desktop.base.gtk = {
		themeName = lib.mkOption {
			type = lib.types.str;
			default = "catppuccin-macchiato-blue-standard";
		};
		themePackage = lib.mkOption {
			type = lib.types.package;
			default = pkgs.catppuccin-gtk.override {
				accents = [ "blue" ];
				size = "standard";
				variant = "macchiato";
			};
		};
	};

	config = {
		home-manager.users.${username} = {
			gtk = {
				enable = true;
				font = {
					name = config.desktop.base.fontName;
					size = config.desktop.base.fontSize;
				};
				theme = {
					name = cfg.themeName;
					package = cfg.themePackage;
				};
				iconTheme = {
					name = config.desktop.base.iconThemeName;
					package = config.desktop.base.iconThemePackage;
				};
				cursorTheme = {
					name = config.desktop.base.cursor.name;
					package = config.desktop.base.cursor.package;
				};

				gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
				gtk4 = {
					theme = null;
					extraConfig.gtk-application-prefer-dark-theme = true;
				};
			};

			dconf.settings."org/gnome/desktop/interface" = {
				gtk-theme = cfg.themeName;
				color-scheme = "prefer-dark";
			};
		};
	};
}
