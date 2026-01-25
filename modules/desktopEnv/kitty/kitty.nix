{ pkgs, username, ... }:
{
environment.systemPackages = with pkgs; [
	kitty
	alacritty
];
home-manager.users.${username} = {
	xdg.configFile = {
	"kitty/" = {
		force = true;
		recursive = true;
		source = ./config;
	};
	};
};

xdg.mime.defaultApplications = {
	"x-scheme-handler/terminal" = "kitty-open.desktop";
};
environment.sessionVariables.TERMINAL = "kitty";
}
