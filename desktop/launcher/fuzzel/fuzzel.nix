{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.launcher.fuzzel;
in
{
	options.desktop.launcher.fuzzel.enable = lib.mkEnableOption "fuzzel launcher";

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ fuzzel ];

		home-manager.users.${username} = {
			xdg.configFile."fuzzel/" = {
				force = true;
				recursive = true;
				source = ./.;
			};
		};
	};
}
