{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.base.cursor;
in
{
	options.desktop.base.cursor = {
		name = lib.mkOption {
			type = lib.types.str;
			default = "breeze_cursors";
		};
		package = lib.mkOption {
			type = lib.types.package;
			default = pkgs.kdePackages.breeze;
		};
		size = lib.mkOption {
			type = lib.types.int;
			default = 12;
		};
	};

	config = {
		home-manager.users.${username} = {
			home.pointerCursor = {
				gtk.enable = true;
				name = cfg.name;
				package = cfg.package;
				size = cfg.size;
			};

			home.sessionVariables = {
				XCURSOR_THEME = cfg.name;
				XCURSOR_SIZE = toString cfg.size;
			};
		};
	};
}
