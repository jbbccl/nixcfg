{ ... }:
{
	imports = [
		./desktopEnv/__desktopEnv__.nix
		./development/__development__.nix
		./services/services.nix
		./shells/__shells__.nix
		./virtual/virtual.nix
		./utilities/utilities.nix
	];
}
