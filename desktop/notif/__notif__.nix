{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (config.desktop.notification == "mako") {
	home-manager.users.${username} = {
		services.mako.enable = true;
		xdg.configFile = mkConfigDir "mako" ./mako;
	};
  };
}
