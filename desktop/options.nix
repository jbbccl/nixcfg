{ lib, ... }: {
	options.desktop = {
		windowManager = lib.mkOption {
			type = lib.types.listOf (lib.types.enum [ "niri" "labwc" "hypr" "mangowc" ]);
			default = [];
		};
		displayManager = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "greetd" "sddm" null ]);
			default = null;
		};
		bar = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "waybar" "noctalia" null ]);
			default = null;
		};
		launcher = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "rofi" "wofi" "fuzzel" null ]);
			default = null;
		};
		lockscreen = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "swaylock" null ]);
			default = null;
		};
		notification = lib.mkOption {
			type = lib.types.nullOr (lib.types.enum [ "mako" "swaync" null ]);
			default = null;
		};
	};
}
