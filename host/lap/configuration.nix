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
}