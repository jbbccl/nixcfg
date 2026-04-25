{ pkgs, username, ... }: {

home-manager.users.${username} = {
	home.packages = with pkgs; [
		nodejs_22
		pnpm
		bun
		#   deno
	];

	# home.sessionVariables = {
	# 	PNPM_HOME = "/home/${username}/.local/share/pnpm";
	# };

	# home.sessionPath = [ "/home/${username}/.local/share/pnpm/bin" ];
};

environment.sessionVariables = rec {
	PNPM_HOME = "/home/${username}/.local/share/pnpm";
	PATH = [ "/home/${username}/.local/share/pnpm" ];
};

}
