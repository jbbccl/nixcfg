{ config, lib, pkgs, ... }:
let
	cfg = config.desktop.base;
in
{
	imports = [
		./fonts.nix
		# ./gtk.nix
		# ./qt.nix
        ./stylix.nix
		./cursor.nix
	];

	options.desktop.base = {
		fontName = lib.mkOption {
			type = lib.types.str;
			default = "Maple Mono NF CN";
		};
		fontSize = lib.mkOption {
			type = lib.types.int;
			default = 12;
		};

		iconThemeName = lib.mkOption {
			type = lib.types.str;
			default = "Papirus-Dark";
		};
		iconThemePackage = lib.mkOption {
			type = lib.types.package;
			default = pkgs.catppuccin-papirus-folders.override {
                flavor = "macchiato";
                accent = "blue";
            };
		};
	};

	config = {
		programs.dconf.enable = true;
	};
}
