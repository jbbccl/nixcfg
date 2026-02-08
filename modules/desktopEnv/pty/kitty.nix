{ pkgs, lib, username, _config_, ... }:
{
	environment.systemPackages = with pkgs; [
	
		kitty
	];

	# programs.kitty是 Home Manager option ，
	# 需要放在home-manager.users.${username}里
	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.enable
	# https://discourse.nixos.org/t/the-option-programs-kitty-does-not-exist/39447

	home-manager.users.${username} = {
		programs.kitty = lib.mkForce {
			enable = true;
			# settings = {};
			extraConfig = ''
			include	current-theme.conf

			font_size ${if _config_ == "lap" 
						then "14"
						else if _config_ == "pc" 
						then "12"
						else "14"}
			font_family			Maple Mono NF CN ExtraLight
			bold_font			Maple Mono NF CN Bold
			italic_font			Maple Mono NF CN Italic
			bold_italic_font	Maple Mono NF CN Bold Italic
			font_features		MapleMono-NF-CN-ExtraLight +cv01 +ss02 +ss04 +ss05 +zero
			font_features		MapleMono-NF-CN-Bold +cv01 +ss02 +ss04 +ss05 +zero
			font_features		MapleMono-NF-CN-Italic +cv01 +ss02 +ss04 +ss05 +zero
			font_features		MapleMono-NF-CN-BoldItalic +cv01 +ss02 +ss04 +ss05 +zero

			# window
			hide_window_decorations		titlebar-only
			window_padding_width		0
			background_opacity			0.80
			# background_blur			32
			remember_window_size		no

			# tab bar
			tab_bar_edge                top
			tab_bar_style               powerline
			tab_powerline_style         slanted

			#key map
			map ctrl+s send_text all \e:w\r
			map cmd+1 combine : send_key ctrl+space : send_key 1

			#url
			mouse_map left click grabbed,ungrabbed discard_event
			mouse_map ctrl+left press grabbed discard_event
			mouse_map ctrl+left release ungrabbed mouse_handle_click selection link prompt
			'';
		};

		xdg.configFile = {
			"kitty/current-theme.conf" = {
				force = true;
				recursive = true;
				source = ./config/current-theme.conf;
			};
		};
	};

	xdg.mime.defaultApplications = {
		"x-scheme-handler/terminal" = "kitty";
	};
	environment.sessionVariables={
		TERMINAL = "kitty";
		TERM = "kitty";
	};

}
