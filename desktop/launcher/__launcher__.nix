{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (config.desktop.launcher == "fuzzel") {
	environment.systemPackages = with pkgs; [
		fuzzel
	];

	home-manager.users.${username} = {
		xdg.configFile = mkConfigDir "fuzzel" ./fuzzel;
	};
  };
}
