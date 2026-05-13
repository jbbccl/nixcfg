{ config, pkgs, lib, ... }:
{
	imports = [
		./dolphin.nix
		./thunar.nix
	];

	config = lib.mkIf (lib.length (config.desktop.fileManager or []) > 0) {
		environment.systemPackages = with pkgs; [
			ntfs3g
		];
	};
}
