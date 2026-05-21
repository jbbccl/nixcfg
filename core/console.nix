{ config, lib, pkgs, ... }:
let
	palette = (lib.importJSON ../static/palette.json).macchiato.colors;
	cfg = config.core.console;
in {
	options.core.console.font = lib.mkOption {
		type = lib.types.str;
		default = "ter-v22b";
		description = "TTY console font (console backend only)";
	};

	config = {
		console = {
			enable = true;
			earlySetup = true;
			font = cfg.font;
			packages = [ pkgs.terminus_font ];
			useXkbConfig = true;
			colors = map (which_color: (lib.substring 1 6 palette.${which_color}.hex)) [
				"base" "red" "green" "yellow" "blue" "pink" "teal" "subtext1"
				"surface2" "red" "green" "yellow" "blue" "pink" "teal" "subtext0"
			];
		};
	};
}
