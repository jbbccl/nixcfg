{ config, pkgs, lib, ... }:
let
	xterm = pkgs.writeShellScriptBin "xterm" ''
        exec ${pkgs.kitty}/bin/kitty "$@"
    '';
in {
	imports = [
		./kitty.nix
		./alacritty.nix
	];

	config = lib.mkIf (config.desktop.terminal == "kitty") {
		environment.systemPackages = [ xterm ];
	};
}
