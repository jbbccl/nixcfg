{ config, pkgs, lib, username, hostName, ... }:
lib.mkIf (config.desktop.terminal == "alacritty") {
	environment.systemPackages = with pkgs; [
		alacritty
	];
}
