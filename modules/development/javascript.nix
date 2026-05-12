{ config, pkgs, lib, username, ... }:
lib.mkIf (builtins.elem "javascript" config.modules.development.languages) {

	home-manager.users.${username} = {
		home.packages = with pkgs; [
			nodejs
			pnpm
			bun
		];

		home.sessionVariables = {
			PNPM_HOME = "/home/${username}/.local/share/pnpm";
		};
		home.sessionPath = [ "/home/${username}/.local/share/pnpm" ];
	};
}
