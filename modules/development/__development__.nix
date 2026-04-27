{ lib, username, ... }: let
  inherit (import ../../lib/helpers.nix { inherit lib; })
    mkNullOrEnum mkNullOrListEnum;
in {
	options.development.languages = mkNullOrListEnum "langs" [
		"c-cpp"
		"go"
		"java"
		"javascript"
		"python"
		"rust"
	];

	imports = [
		./git.nix

		./c-cpp.nix
		./javascript.nix
		./python.nix
		./rust.nix
		./go.nix
		./java.nix
	];

	config.development.languages = [ "c-cpp" "javascript" "python" "rust" ];
	
	config.environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
