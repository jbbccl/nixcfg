{ pkgs, username, ... }:
{
# programs.waybar.enable = true;
	environment.systemPackages = with pkgs; [
		waybar
		fuzzel
		wofi
		swaylock 
		mako 
		swayidle 
		brightnessctl#亮度调节re
		networkmanagerapplet
	];
	
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