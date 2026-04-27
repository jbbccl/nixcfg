{ config, lib, pkgs, username, ... }:
let
  inherit (import ../../lib/helpers.nix { inherit lib; }) mkConfigDir;
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
