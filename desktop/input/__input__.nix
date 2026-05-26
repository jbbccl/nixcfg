{ config, lib, ... }:
let
	mkInputEnable = name: lib.mkDefault (config.desktop.input.select == name);
in
{
	imports = [
		./rime/rime.nix
		./fcitx5/fcitx5.nix
	];

	options.desktop.input.select = lib.mkOption {
		type = lib.types.nullOr (lib.types.enum [ "fcitx5" ]);
		default = null;
		description = "input method framework";
	};

	config = lib.mkIf (config.desktop.input.select != null) {
        desktop.input.rime.enable = lib.mkDefault true;
		desktop.input.fcitx5.enable = mkInputEnable "fcitx5";
	};
}
