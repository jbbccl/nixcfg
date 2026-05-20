{ config, lib, pkgs, username, ... }:
{
	options.modules.shells.enable = lib.mkEnableOption "shells";

	imports = [
		# ./bash/bash.nix
		./fish/fish.nix
		./zsh/zsh.nix
	];

	config = lib.mkIf config.modules.shells.enable {
		users.users.${username}.shell = pkgs.fish;
	};
}
