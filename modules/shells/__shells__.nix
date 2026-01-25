{ username, pkgs, ... }:
{
	imports = [
		./fish/fish.nix
		./zsh/zsh.nix
  ];
  users.users.${username}.shell = pkgs.fish;
}
