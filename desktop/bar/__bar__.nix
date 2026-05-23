{ config, lib, ... }:
let
	mkBarEnable = name: lib.mkDefault (builtins.elem name config.desktop.bar.list);
in
{
	imports = [
		./waybar/waybar.nix
		./noctalia/default.nix
	];

	options.desktop.bar.list = lib.mkOption {
		type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "waybar" "noctalia" ]));
		default = null;
		description = "status bar";
	};

	config = lib.mkIf (config.desktop.bar.list != null) {
		desktop.bar.waybar.enable   = mkBarEnable "waybar";
		desktop.bar.noctalia.enable = mkBarEnable "noctalia";
	};
}
