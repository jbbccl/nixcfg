{ config, pkgs, username, ... }:
{
# 1. 系统级安装（让所有用户都能使用）
programs.fish.enable = true;

home-manager.users.${username} = {
	xdg.configFile = {
		"fish/" = {
			force = true;
			recursive = true;
			source = ./config;
		};
		"fish/config.fish" = {
			force = true;
			recursive = true;
			text = ''
			if status is-interactive
			set fish_greeting
			fish_config theme choose "Catppuccin Mocha"
			end'';
		};
		"fish/completions/uvx.fish" = {
			force = true;
			recursive = true;
			text = "uvx --generate-shell-completion fish | source";
		};
	};
};
}
