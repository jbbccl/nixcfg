{ pkgs, username, ... }:
{
		# imports = [./nixvim];
	# programs.neovim.enable = true;
	environment.sessionVariables = {
		VISUAL = "nvim";
		EDITOR = "nvim";
	};
}
