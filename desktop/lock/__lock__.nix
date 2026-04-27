{ config, lib, pkgs, username, ... }:
let
  inherit (import ../../lib/helpers.nix { inherit lib; }) mkConfigDir;
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
