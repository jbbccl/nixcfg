{ pkgs, username, ... }: {

home-manager.users.${username} = {
	home.packages = with pkgs; [
		nodejs_22
		pnpm
		#   bun
		#   deno
	];

home.sessionVariables = {
	PNPM_HOME = "/home/${username}/.local/share/pnpm";
};

home.file.".npmrc".text = ''
registry=https://registry.npmmirror.com/
global-bin-dir=/home/${username}/.local/share/pnpm/bin
store-dir=/home/${username}/.pnpm-store
'';

};

}
