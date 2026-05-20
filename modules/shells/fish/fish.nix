{ config, lib, pkgs, username, ... }:
{
	options.modules.shells.fish.enable = lib.mkEnableOption "fish shell";

	config = lib.mkIf config.modules.shells.fish.enable {
		programs.fish.enable = true;
		programs.fish.shellInit = ''
			function nix-shell --wraps nix-shell
			command nix-shell --command "exec fish" $argv
			end
		'';
		home-manager.users.${username} = {
			programs.fish.enable = true;
			xdg.configFile."fish/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};
}
