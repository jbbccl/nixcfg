{ config, lib, ... }:
let
	mkLauncherEnable = name: lib.mkDefault (config.desktop.launcher.select == name);
in
{
	imports = [
		./fuzzel/fuzzel.nix
		./rofi/rofi.nix
		./wofi/wofi.nix
	];

	options.desktop.launcher.select = lib.mkOption {
		type = lib.types.nullOr (lib.types.enum [ "fuzzel" "rofi" "wofi" ]);
		default = null;
		description = "app launcher";
	};

	config = lib.mkIf (config.desktop.launcher.select != null) {
		desktop.launcher.fuzzel.enable = mkLauncherEnable "fuzzel";
		desktop.launcher.rofi.enable   = mkLauncherEnable "rofi";
		desktop.launcher.wofi.enable   = mkLauncherEnable "wofi";
	};
}
