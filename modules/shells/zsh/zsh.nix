{ config, lib, pkgs, username, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  environment.sessionVariables = {
    ZDOTDIR = "$HOME/.config/zsh";
  };
  home-manager.users.${username} = {
    home.file.".config/zsh" = {
		force = true;
		recursive = true;
		source = ./config;
	};
  };
}
