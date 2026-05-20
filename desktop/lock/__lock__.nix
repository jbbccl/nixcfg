{ config, lib, ... }:
{
	options.desktop.lock.select = lib.mkOption {
		type = lib.types.nullOr (lib.types.enum [ "swaylock" ]);
		default = null;
		description = "lock screen";
	};

	imports = [
		./swaylock/swaylock.nix
	];

	config = lib.mkIf (config.desktop.lock.select == "swaylock") {
		desktop.lock.swaylock.enable = lib.mkDefault true;
	};
}
