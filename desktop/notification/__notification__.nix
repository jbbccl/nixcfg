{ config, lib, pkgs, username, ... }:
let
  inherit (import ../../lib/helpers.nix { inherit lib; }) mkConfigDir;
in {
  config = lib.mkIf (config.desktop.notification == "mako") {
	home-manager.users.${username} = {
		services.mako.enable = true;
		xdg.configFile = mkConfigDir "mako" ./mako;
	};
  };
}
