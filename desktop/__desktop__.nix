{ config, lib, helpers, ... }:
let
	inherit (helpers)
		mkNullOrEnum mkNullOrListEnum;
in {
	options.desktop = {
		enable = lib.mkEnableOption "desktop environment (WM, bar, DM, theme, etc.)";
		windowManager = mkNullOrListEnum "window managers" [
			"niri" "labwc" "hypr" "mangowc"
		];
		bar = mkNullOrListEnum "status bar" [ 
			"waybar" "noctalia" 
		];
		displayManager = mkNullOrEnum "display manager" [ "greetd" "sddm" ];
		launcher = mkNullOrEnum "app launcher" [ "fuzzel" "rofi" "wofi" ];
		lockscreen = mkNullOrEnum "lock screen" [ "swaylock" ];
		notification = mkNullOrEnum "notification daemon" [ "mako" "swaync" ];
	};

	imports = [
		./base/__base__.nix
		./display-manager/__displayMgr__.nix
		./window-manager/__winMgr__.nix
		./status-bar/__bar__.nix
		./launcher/__launcher__.nix
		./lock/__lock__.nix
		./notification/__notification__.nix
		./input/__input__.nix
		./wallpaper/__wallpaper__.nix
		# ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
	];

	config = lib.mkMerge [
		{ desktop.enable = lib.mkDefault true; }
		(lib.mkIf config.desktop.enable {
			desktop.windowManager = [ "labwc" "niri" "hypr" ];
			desktop.bar = [ "waybar"];
			desktop.launcher = "fuzzel";
			desktop.lockscreen = "swaylock";
			desktop.notification = "mako";
			desktop.displayManager = "greetd";
		})
	];
}
