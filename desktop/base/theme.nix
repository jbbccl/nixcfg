{ config, pkgs, username, lib, ... }:
let
	fontName = "Maple Mono NF CN";
	fontSize = config.desktop.base.fontSize;

	gtkThemeName = "catppuccin-macchiato-blue-standard";
	gtkThemePkg = pkgs.catppuccin-gtk.override {
		accents = [ "blue" ];
		size = "standard";
		variant = "macchiato";
	};

	iconThemeName = "Papirus-Dark";
	iconThemePkg = pkgs.catppuccin-papirus-folders.override {
		flavor = "macchiato";
		accent = "blue";
	};

	cursorsThemeName = "breeze_cursors";
	cursorsThemePkg = pkgs.kdePackages.breeze;

	cursorSize = 12;

in {
	options.desktop.base.fontSize = lib.mkOption {
		type = lib.types.int;
		description = "base font size";
	};

	config = {
		home-manager.users.${username} = {
			home.pointerCursor = {
				gtk.enable = true;
				name = cursorsThemeName;
				package = cursorsThemePkg;
				size = cursorSize;
			};

			home.sessionVariables = {
				XCURSOR_THEME = cursorsThemeName;
				XCURSOR_SIZE = toString cursorSize;
			};

			gtk = {
				enable = true;
				font = {
					name = fontName;
					size = fontSize;
				};
				theme = {
					name = gtkThemeName;
					package = gtkThemePkg;
				};
				iconTheme = {
					name = iconThemeName;
					package = iconThemePkg;
				};
				cursorTheme = {
					name = cursorsThemeName;
					package = cursorsThemePkg;
				};

				gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
				gtk4 = {
					theme = null;
					extraConfig.gtk-application-prefer-dark-theme = true;
				};
			};

			dconf.settings."org/gnome/desktop/interface" = {
				gtk-theme = gtkThemeName;
				color-scheme = "prefer-dark";
			};

			qt = {
				enable = true;
				platformTheme.name = "gtk3";
			};
		};

		environment.sessionVariables = {
			QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
		};
	};
}
