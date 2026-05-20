{ config, lib, ... }:
{
	options.modules.utilities.enable = lib.mkEnableOption "utilities";

	imports = [
		./neovim/neovim.nix
		./yazi/yazi.nix
		./basic-tools.nix
	];
}
