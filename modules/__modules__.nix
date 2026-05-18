{ lib, ... }:
{
	imports = [
		./development/__development__.nix
		./services/__services__.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];

	config.modules = {
		development.languages = [ "c-cpp" "javascript" "python" "rust" ];
	};
}
