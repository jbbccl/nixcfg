{ config, pkgs, username, ... }:
{
programs.fish.enable = true;

programs.fish.shellInit = ''
	function nix-shell --wraps nix-shell
	command nix-shell --command "exec fish" $argv
''; 

home-manager.users.${username} = {
	# programs.fish.enable = true;
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
			alias sduo=sudo
			alias nv=nvim
			alias docker=podman
			alias pd=podman
			alias db=distrobox
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
