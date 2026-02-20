{ ... }:
{
	imports = [
		# ./desktopEnv/__desktopEnv__.nix
		./development/__development__.nix
		./services/services.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];
}
