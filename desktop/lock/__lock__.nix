{ config, lib, pkgs, username, helpers, ... }:
let
  inherit (helpers) mkConfigDir;
in {
  config = lib.mkIf (config.desktop.lockscreen == "swaylock") {
	environment.systemPackages = with pkgs; [
		swaylock
	];

	home-manager.users.${username} = {
		xdg.configFile = mkConfigDir "swaylock" ./swaylock;
	};
  };
}
