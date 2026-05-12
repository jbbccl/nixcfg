{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "java" config.modules.development.languages) {

	home-manager.users.${username} = {
		home.packages = with pkgs; [
			jdk
		];
	};
}
