{ pkgs, username, ... }:
{
# programs.waybar.enable = true;
	environment.systemPackages = with pkgs; [
		waybar
		fuzzel
		wofi
		swaylock 
		swayidle 
		brightnessctl#亮度调节re
		networkmanagerapplet
	];
	
	home-manager.users.${username} = {
		xdg.configFile = {
			"waybar/" = {
				force = true;
				recursive = true;
				source = ./waybar;
			};
		};
		
		services.mako.enable = true;
		xdg.configFile = {
			"mako/" = {
				force = true;
				recursive = true;
				source = ./mako;
			};
		};
		xdg.configFile = {
			"wofi/" = {
				force = true;
				recursive = true;
				source = ./wofi;
			};
		};
	};

}


# services.mako.settings={
# 	"actionable=true" = {
# 		anchor = "bottom-left";
# 	};
# 	actions = true;
# 	anchor = "bottom-right";
# 	background-color = "#000000";
# 	border-color = "#FFFFFF";
# 	border-radius = 0;
# 	default-timeout = 0;
# 	font = "Maple Mono NF CN 10";
# 	height = 100;
# 	icons = true;
# 	ignore-timeout = false;
# 	layer = "top";
# 	margin = 10;
# 	markup = true;
# 	width = 300;
# };