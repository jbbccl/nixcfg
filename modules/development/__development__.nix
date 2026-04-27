{ lib, username, ... }: {
	options.development.languages = lib.mkOption {
		type = lib.types.listOf (lib.types.enum [
			"c-cpp"
			"go"
			"java"
			"javascript"
			"python"
			"rust"
		]);
		default = [ "c-cpp" "javascript" "python" "rust" ];
		description = "Languages to enable development tooling for";
	};

	imports = [
		./git.nix

		./c-cpp.nix
		./javascript.nix
		./python.nix
		./rust.nix
		./go.nix
		./java.nix
	];

	config.environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
