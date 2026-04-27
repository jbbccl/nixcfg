{ lib, ... }: {
	options.desktop = {
		enable = lib.mkEnableOption "desktop environment (WM, bar, DM, theme, etc.)";

		windowManager = lib.mkOption {
			type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "niri" "labwc" "hypr" "mangowc" ]));
			default = null;
		};
		displayManager = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "greetd" "sddm" ]);
			default = null;
		};
		bar = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "waybar" "noctalia" ]);
			default = null;
		};
		launcher = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "rofi" "wofi" "fuzzel" ]);
			default = null;
		};
		lockscreen = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "swaylock" ]);
			default = null;
		};
		notification = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "mako" "swaync" ]);
			default = null;
		};
	};
}
