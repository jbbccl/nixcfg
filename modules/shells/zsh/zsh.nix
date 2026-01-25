{ config, pkgs, username, ... }:
{
# 1. 系统级安装（让所有用户都能使用）
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
    home.file = {
      ".config/zsh" = {
        source = ./config;
        force = true;
        recursive = true;
      };
    };
};
}