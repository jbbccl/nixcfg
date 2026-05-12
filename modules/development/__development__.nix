{ config, lib, username, helpers, ... }: let
  inherit (helpers)
    mkNullOrEnum mkNullOrListEnum;
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
	
	environment.sessionVariables = {
		PATH = [ "/home/${username}/.local/bin" ];
	};
}
