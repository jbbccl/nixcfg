{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "java" config.modules.dev.lang) {

	home-manager.users.${username} = {
		home.packages = with pkgs; [
			jdk
		];
	};
}
