{ username, pkgs, lib, ... }:{
	imports = [
		# ./bash/bash.nix
		./fish/fish.nix
		./zsh/zsh.nix
	];
	users.users.${username}.shell = pkgs.fish;
}
