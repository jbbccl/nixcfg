# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
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

	desktop.windowManager = "niri";
	desktop.bar = "waybar";
	desktop.launcher = "fuzzel";
	desktop.lockscreen = "swaylock";
	desktop.notification = "mako";
	desktop.displayManager = "greetd";
}