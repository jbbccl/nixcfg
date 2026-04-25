{ username, ... }:
{
	imports = [
		./git.nix

		./c-cpp.nix
		./javascript.nix
		./python.nix
		./rust.nix
	];

	environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
