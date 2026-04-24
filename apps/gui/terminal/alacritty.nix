{ pkgs, lib, username, hostName, ... }:
{
	environment.systemPackages = with pkgs; [
		alacritty
	];
	
}