{ config, lib, username, ... }: {
  config = lib.mkIf (config.desktop.notification == "mako") {
	home-manager.users.${username} = {
		services.mako.enable = true;
		xdg.configFile = {
			"mako/" = {
				force = true;
				recursive = true;
				source = ./mako;
			};
		};
	};
  };
}
