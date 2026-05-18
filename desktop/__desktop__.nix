{ config, lib, helpers, ... }:
let
	inherit (helpers)
		mkNullOrEnum mkNullOrListEnum;
in {
	imports = [
		./base/__base__.nix
		./dispMgr/__dispMgr__.nix
		./winMgr/__winMgr__.nix
		./bar/__bar__.nix
		./launcher/__launcher__.nix
		./lock/__lock__.nix
		./notif/__notif__.nix
		./input/__input__.nix
		./wallpaper/__wallpaper__.nix
		./term/__term__.nix
		./fileMgr/__fileMgr__.nix
		./browser/__browser__.nix
		# ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
	];

	options.desktop = {
		enable = lib.mkEnableOption "desktop environment (WM, bar, DM, theme, etc.)";
		windowManager = mkNullOrListEnum "window managers" [ "niri" "labwc" "hypr" "mangowc" ];
		bar = mkNullOrListEnum "status bar" [ "waybar" "noctalia" ];
		displayManager = mkNullOrEnum "display manager" [ "greetd" "sddm" ];
		launcher = mkNullOrEnum "app launcher" [ "fuzzel" "rofi" "wofi" ];
		lockscreen = mkNullOrEnum "lock screen" [ "swaylock" ];
		notification = mkNullOrEnum "notification daemon" [ "mako" "swaync" ];
		terminal = mkNullOrEnum "terminal emulator" [ "kitty" "alacritty" ];
		fileManager = mkNullOrListEnum "file managers" [ "dolphin" "thunar" ];
	};

	config = lib.mkMerge [
		{ desktop.enable = lib.mkDefault true; }
		(lib.mkIf config.desktop.enable {
			desktop = lib.mkDefault {
				windowManager = [ "labwc" "niri" ];
				bar           = [ "waybar" ];
				launcher      = "fuzzel";
				lockscreen    = "swaylock";
				notification  = "mako";
				displayManager= "greetd";
				terminal      = "kitty";
				fileManager   = [ "dolphin" "thunar" ];
			};
		})
	];
}
