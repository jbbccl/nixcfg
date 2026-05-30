{ config, lib, pkgs, username, ... }:
let
	cfg = config.desktop.wallpaper.waypaper;
in
{
	options.desktop.wallpaper.waypaper.enable = lib.mkEnableOption "waypaper wallpaper manager";

	config = lib.mkIf cfg.enable {
		desktop.wallpaper.awww.enable = lib.mkDefault true;

		environment.systemPackages = [ pkgs.waypaper ];

		home-manager.users.${username} = {
			xdg.configFile."waypaper/config.ini" = {
				force = true;
				recursive = true;
				text = ''[Settings]
                    language = en
                    backend = awww
                    folder = /home/${username}/.local/share/wallpapers
                    monitors = All
                    show_path_in_tooltip = True
                    fill = fill
                    sort = name
                    color = #ffffff
                    subfolders = True
                    all_subfolders = True
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
                    stylesheet = /home/${username}/.config/waypaper/style.css
                    keybindings = ~/.config/waypaper/keybindings.ini
				'';
			};
		};
	};
}
