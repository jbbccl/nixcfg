{ config, lib, ... }:
let
	mkBarEnable = name: lib.mkDefault (builtins.elem name config.desktop.bar.list);
in
{
	imports = [
		./waybar/waybar.nix
		./ironbar/ironbar.nix
		./noctalia/noctalia.nix
	];

	options.desktop.bar.list = lib.mkOption {
		type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "waybar" "ironbar" "noctalia" ]));
		default = null;
		description = "status bar";
	};

	config = lib.mkIf (config.desktop.bar.list != null) {
		desktop.bar.waybar.enable    = mkBarEnable "waybar";
		desktop.bar.ironbar.enable   = mkBarEnable "ironbar";
		desktop.bar.noctalia.enable  = mkBarEnable "noctalia";
	};
}
