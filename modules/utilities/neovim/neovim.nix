{ pkgs, ... }:
{
		# imports = [./nixvim];
	# programs.neovim.enable = true;
	environment.systemPackages = with pkgs; [neovim];
	environment.sessionVariables = {
		VISUAL = "nvim";
		EDITOR = "nvim";
	};
}
