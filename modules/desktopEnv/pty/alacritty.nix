{ pkgs, lib, username, _config_, ... }:
{
	environment.systemPackages = with pkgs; [
		alacritty
	];
	
}