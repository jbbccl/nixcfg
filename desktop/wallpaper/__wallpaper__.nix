{ pkgs, username, ... }:
{
	environment.systemPackages = with pkgs; [
		waypaper
		awww
	];
	home-manager.users.${username} = {
		xdg.configFile = {
			"waypaper/config.ini" = {
				force = true;
				recursive = true;
				text=''[Settings]
language = en
backend = awww
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
awww_transition_type = any
awww_transition_step = 63
awww_transition_angle = 0
awww_transition_duration = 2
awww_transition_fps = 60
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
