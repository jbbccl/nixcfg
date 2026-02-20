{ lib, ... }:
let
	palette = (lib.importJSON ../static/palette.json).macchiato.colors;
in{
	services.xserver = {
		xkb = {
			layout = "us";  # 或其他布局
			options = "caps:swapescape";# 交换 CapsLock 和 Escape
		};
	};

	console = {
		font = "Lat2-Terminus16";
		# keyMap = "us";
		useXkbConfig = true;
		colors = map (which_color: (lib.substring 1 6 palette.${which_color}.hex)) [
			"base" "red" "green" "yellow" "blue" "pink" "teal" "subtext1"
			"surface2" "red" "green" "yellow" "blue" "pink" "teal" "subtext0"
		];
	};
}
