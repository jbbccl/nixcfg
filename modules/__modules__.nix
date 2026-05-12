{ lib, ... }:
let
	inherit (import ../lib/helpers.nix { inherit lib; })
		mkNullOrListEnum;
in {
	imports = [
		./development/__development__.nix
		./services/__services__.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];

	options.modules = {
		development.languages = mkNullOrListEnum "langs" [ 
			"c-cpp" "go" "java" "javascript" "python" "rust"
		];
	};

	config.modules = {
		development.languages = [ "c-cpp" "javascript" "python" "rust" ];
	};
}
