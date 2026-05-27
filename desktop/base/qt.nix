{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.base.qt;
	base = config.desktop.base;

	qt5ct = lib.generators.toINI { } {
		Appearance = {
			icon_theme = base.iconThemeName;
			style = "kvantum";
			standard_dialogs = "xdgdesktopportal";
		};
		Fonts = {
			general = ''"${base.fontName},${toString base.fontSize}"'';
			fixed = ''"${base.fontName},${toString base.fontSize}"'';
		};
	};
in
{
	options.desktop.base.qt = {
		platformTheme = lib.mkOption {
			type = lib.types.str;
			default = "qtct";
		};
		style = lib.mkOption {
			type = lib.types.str;
			default = "kvantum";
		};
		kvantumName = lib.mkOption {
			type = lib.types.str;
			default = "catppuccin-macchiato-blue";
		};
		kvantumPackage = lib.mkOption {
			type = lib.types.package;
			default = pkgs.catppuccin-kvantum.override {
				variant = "macchiato";
				accent = "blue";
			};
		};
	};

	config = {
		home-manager.users.${username} = {
			qt = {
				enable = true;
				platformTheme.name = cfg.platformTheme;
				style.name = cfg.style;

				kvantum = {
					enable = true;
					themes = [ cfg.kvantumPackage ];
					settings.General.theme = cfg.kvantumName;
				};
			};

			xdg.configFile = {
				"qt5ct/qt5ct.conf".text = qt5ct;
				"qt6ct/qt6ct.conf".text = qt5ct;
			};

			home.packages = with pkgs; [
				libsForQt5.qtstyleplugin-kvantum
				qt6Packages.qtstyleplugin-kvantum
			];
		};
	};
}
