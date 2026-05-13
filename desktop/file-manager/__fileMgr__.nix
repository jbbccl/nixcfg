{ config, pkgs, lib, ... }:
{
	imports = [
		./dolphin.nix
		./thunar.nix
	];

	config = lib.mkIf (config.desktop.fileManager != null) {
		environment.systemPackages = with pkgs; [
			ntfs3g
		];
	};
}
