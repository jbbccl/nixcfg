{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.base.gtk;
	base = config.desktop.base;
in
{
	options.desktop.base.gtk = lib.mkOption {
		type = lib.types.submodule {
			options = {
				enable = lib.mkEnableOption "GTK theming";
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
		};
		default = { };
	};

	config = lib.mkIf cfg.enable {
		home-manager.users.${username} = {
			gtk = {
				enable = true;
				font = {
					name = base.fontName;
					size = base.fontSize;
				};
				theme = {
					name = cfg.themeName;
					package = cfg.themePackage;
				};
				iconTheme = {
					name = base.iconThemeName;
					package = base.iconThemePackage;
				};
				cursorTheme = {
					name = base.cursor.name;
					package = base.cursor.package;
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
