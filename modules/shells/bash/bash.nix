{ pkgs, username, ... }:
{
	programs.bash.enable = true;
	programs.bash.interactiveShellInit = ''
		if [ -f ~/.config/bash/bashrc ]; then
		. ~/.config/bash/bashrc
		fi
	'';

	home-manager.users.${username} = {
		home.file.".config/bash" = {
		source = ./config;
		force = true;
		recursive = true;
		};
	};
}
