{ config, lib, pkgs, username, ... }: {
  config = lib.mkIf (config.desktop.lockscreen == "swaylock") {
	environment.systemPackages = with pkgs; [
		swaylock
	];

	home-manager.users.${username} = {
		xdg.configFile = {
			"swaylock/" = {
				force = true;
				recursive = true;
				source = ./swaylock;
			};
		};
	};
  };
}
