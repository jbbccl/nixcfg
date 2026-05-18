{ config, lib, username, helpers, ... }: let
  inherit (helpers) mkNullOrListEnum;
in {
	imports = [
		./git.nix

		./c-cpp.nix
		./javascript.nix
		./python.nix
		./rust.nix
		./go.nix
		./java.nix
	];

	options.modules = {
		development.languages = mkNullOrListEnum "langs" [ 
			"c-cpp" "go" "java" "javascript" "python" "rust"
		];
	};
	
	config.environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
