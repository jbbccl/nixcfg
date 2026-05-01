{ config, lib, username, helpers, ... }: let
  inherit (helpers)
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

	config = lib.mkIf config.modules.development.enable  {
		development.languages = [ "c-cpp" "javascript" "python" "rust" ];
		environment.sessionVariables = {
			PATH = [ "/home/${username}/.local/bin" ];
		};
	};
}
