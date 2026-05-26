{ config, lib, ... }:
let
	mkFileMgrEnable = name: lib.mkDefault (builtins.elem name config.desktop.fileMgr.list);
in
{
	imports = [
		./dolphin/dolphin.nix
		./thunar/thunar.nix
	];

	options.desktop.fileMgr.list = lib.mkOption {
		type = lib.types.nullOr (lib.types.listOf (lib.types.enum [ "dolphin" "thunar" ]));
		default = null;
		description = "file managers";
	};

	config = lib.mkIf (config.desktop.fileMgr.list != null) {
		desktop.fileMgr.dolphin.enable = mkFileMgrEnable "dolphin";
		desktop.fileMgr.thunar.enable = mkFileMgrEnable "thunar";
	};
}
