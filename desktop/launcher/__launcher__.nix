{ config, lib, pkgs, username, ... }: {
  config = lib.mkIf (config.desktop.launcher == "fuzzel") {
	environment.systemPackages = with pkgs; [
		fuzzel
	];

	home-manager.users.${username} = {
		xdg.configFile = {
			"fuzzel/" = {
				force = true;
				recursive = true;
				source = ./fuzzel;
			};
		};
	};
  };
}
