{ config, lib, pkgs, username, ... }:
{
	imports = [
		./hardware-configuration.nix
		./driver.nix
		./boot.nix
		../common.nix
	];

	system.stateVersion = "25.11";
	home-manager.users.${username}.home.stateVersion = "25.11";

	desktop.windowManager = "labwc";
	desktop.bar = "waybar";
	desktop.launcher = "fuzzel";
	desktop.lockscreen = "swaylock";
	desktop.notification = "mako";
	desktop.displayManager = "greetd";
}
