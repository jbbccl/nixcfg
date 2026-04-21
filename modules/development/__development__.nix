{ ... }:
{
imports = [
	./git.nix

	./c-cpp.nix
	./nodejs.nix
	# ./go.nix
	./python.nix
	./rust.nix
	# ./java.nix
	./AI
];

environment.sessionVariables = rec {
	PATH = ["/home/e/.local/bin"];
};

}
