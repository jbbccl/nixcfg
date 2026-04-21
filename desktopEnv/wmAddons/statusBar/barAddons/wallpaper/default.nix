{ pkgs, username, ... }:
{
	environment.systemPackages = with pkgs; [
		waypaper
		swww
	];
	home-manager.users.${username} = {
		services.mako.enable = true;
		xdg.configFile = {
			"waypaper/config.ini" = {
				force = true;
				recursive = true;
				text=''[Settings]
language = en
backend = swww
folder = ~/nixcfg/static/wallpaper
monitors = All
wallpaper = ~/nixcfg/static/wallpaper/wallpaper.jpg
show_path_in_tooltip = True
fill = fill
sort = name
color = #ffffff
subfolders = False
all_subfolders = False
show_hidden = False
show_gifs_only = False
zen_mode = False
post_command = 
number_of_columns = 3
swww_transition_type = any
swww_transition_step = 63
swww_transition_angle = 0
swww_transition_duration = 2
swww_transition_fps = 60
mpvpaper_sound = False
mpvpaper_options = 
use_xdg_state = False
stylesheet = /home/e/.config/waypaper/style.css
keybindings = ~/.config/waypaper/keybindings.ini
'';
			};
		};
	};
}
