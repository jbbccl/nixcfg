{ config, lib, pkgs, inputs, username, ... }:
let
	cfg = config.desktop.bar.noctalia;
in
{
	options.desktop.bar.noctalia.enable = lib.mkEnableOption "noctalia status bar";

	config = lib.mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			# networkmanagerapplet
			inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
		];

		services = {
			upower.enable = true;
			power-profiles-daemon.enable = true;
		};
        home-manager.users.${username} = {
            xdg.configFile."noctalia" = {
                force = true;
                recursive = true;
                source = ./config;
            };
        };
	};
}
