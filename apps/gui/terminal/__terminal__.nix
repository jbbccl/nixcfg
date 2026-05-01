{ pkgs, ... }:
let
	imxterm = pkgs.writeShellScriptBin "xterm" ''
		exec ${pkgs.kitty}/bin/kitty "$@"
	'';
in
{
	environment.systemPackages = with pkgs; [
		imxterm
	];
	imports = [
		./kitty.nix
		./alacritty.nix
	];
}