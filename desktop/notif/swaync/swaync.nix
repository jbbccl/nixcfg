{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.notif.swaync;
in
{
	options.desktop.notif.swaync.enable = lib.mkEnableOption "swaync notification daemon";

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [ swaynotificationcenter ];

		home-manager.users.${username} = {
			services.swaync.enable = true;
			xdg.configFile."swaync/" = {
				force = true;
				recursive = true;
				source = ./.;
			};
		};
	};
}
