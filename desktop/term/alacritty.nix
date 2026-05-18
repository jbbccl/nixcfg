{ config, pkgs, lib, username, hostName, ... }:
lib.mkIf (config.desktop.term.select == "alacritty") {
	environment.systemPackages = with pkgs; [
		alacritty
	];
}
