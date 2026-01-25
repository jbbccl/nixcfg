{ ... }:
{
	imports = [
		./desktopEnv/__desktopEnv__.nix
		./development/__development__.nix
		./neovim/neovim.nix
		./services/services.nix
		./shells/__shells__.nix
		./virtual/virtual.nix

		./cli.nix

  ];
}
