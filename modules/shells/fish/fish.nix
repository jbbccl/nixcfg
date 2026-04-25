{ config, pkgs, username, ... }:
{

programs.fish.enable = true;

programs.fish.shellInit = ''
	function nix-shell --wraps nix-shell
	command nix-shell --command "exec fish" $argv
	end
'';

home-manager.users.${username} = {
	programs.fish.enable = true; # 加上HM才能设置环境变量

	xdg.configFile = {
		"fish/" = {
			force = true;
			recursive = true;
			source = ./config;
		};
		"fish/completions/uvx.fish" = {
			force = true;
			recursive = true;
			text = "uvx --generate-shell-completion fish | source";
		};
	};
};
}
