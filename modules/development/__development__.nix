{ username, ... }:
{
	imports = [
		./git.nix

		./c-cpp.nix
		./nodejs.nix
		./python.nix
		./rust.nix
	];

	environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
