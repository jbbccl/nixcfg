{ config, pkgs, lib, ... }:
lib.mkIf (config.desktop.term.select == "alacritty") {
	environment.systemPackages = with pkgs; [
		alacritty
	];
}
