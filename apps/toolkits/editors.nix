{ config, lib, pkgs, username, ... }:
let
	cfg = config.apps.toolkits.editors;

	codium-with-code = pkgs.symlinkJoin {
		name = "codium-with-code";
		paths = [ pkgs.vscodium ];
		postBuild = ''
			ln -sf codium $out/bin/code
		'';
	};
in
{
	options.apps.toolkits.editors.enable = lib.mkEnableOption "editor tools (vscode, codium)";

	config = lib.mkIf cfg.enable {
		home-manager.users.${username}.home.packages = with pkgs; [
			# vscode
			codium-with-code
			zed-editor
		];
	};
}
