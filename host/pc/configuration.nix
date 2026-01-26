# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, username, ... }:
{
	imports = [
		./hardware-configuration.nix
		./subFileList.nix
	];

	boot.kernelPackages = pkgs.stable.linuxPackages_zen;

	boot.loader = {
		systemd-boot.enable = true;
		efi = {
			canTouchEfiVariables = true;
			efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
		};
		# grub = {
		# 	efiSupport = true;
		# 	#efiInstallAsRemovable = true; # 如果 canTouchEfiVariables不能用
		# 	device = "nodev";
		# };
	};

	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	system.stateVersion = "25.11";
	home-manager.users.${username}.home.stateVersion = "25.11";
}

