{ pkgs, username, ... }:
{
programs.waybar.enable = true;

home-manager.users.${username} = {
	xdg.configFile = {
	"waybar/" = {
		force = true;
		recursive = true;
		source = ./config;
	};
	};
};

}