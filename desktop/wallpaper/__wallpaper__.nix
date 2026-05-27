{ pkgs, username, ... }:
let
	plasma-walls = pkgs.fetchgit {
		url = "https://github.com/KDE/plasma-workspace-wallpapers.git";
		rev = "d895680ddd3fc379a11d72be80e2bb06984291da";
		sparseCheckout = [ "ScarletTree" "FallenLeaf" "OneStandsOut" "Autumn" "Altai" "BytheWater" ];
		hash = "sha256-3pXc72LFGRaKkpIi/pJ/ngS9ys7jFMy+uOOfkTX8Pds=";
	};
in
{
	environment.systemPackages = with pkgs; [
		waypaper
		awww
	];
	home-manager.users.${username} = {
        home.file.".local/share/wallpapers/plasma" = {
			source = plasma-walls;
			force = true;
			recursive = true;
		};
        home.file.".local/share/wallpapers/collect" = {
			source = ./collect;
			force = true;
			recursive = true;
		};

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
                stylesheet = /home/e/.config/waypaper/style.css
                keybindings = ~/.config/waypaper/keybindings.ini
			'';
		};
	};
}
