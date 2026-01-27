{ pkgs, username, ... }:
{
programs.neovim.enable = true;
environment.sessionVariables = {
	VISUAL = "nvim";
	EDITOR = "nvim";
};
}
