{ pkgs, ... }:{
	imports = [
		./dolphin.nix
		./thunar.nix
	];
	environment.systemPackages = with pkgs; [
		ntfs3g
	];
}