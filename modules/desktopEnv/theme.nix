{ pkgs, username, ... }: 
let
fontName ="Maple Mono NF CN";
fontSize = 11;
#ls $XDG_DATA_DIRS/themes
gtkThemeName = "catppuccin-macchiato-blue-standard";
gtkThemePkg = pkgs.catppuccin-gtk.override {
	accents = [ "blue" ];
	size = "standard";
	variant = "macchiato";
};

#ls $XDG_DATA_DIRS/icons/
iconThemeName = "Papirus-Dark";
iconThemePkg = pkgs.catppuccin-papirus-folders.override {
	flavor = "macchiato";
	accent = "blue";
};

cursorsThemeName = "breeze_cursors";#"catppuccin-macchiato-dark-cursors";
cursorsThemePkg = pkgs.kdePackages.breeze;#pkgs.catppuccin-cursors.macchiatoDark;

cursorSize = 12;

in
{
home-manager.users.${username} = {

	home.pointerCursor = {
		gtk.enable = true;
		name = cursorsThemeName;
		package = cursorsThemePkg;
		size = cursorSize;
	};
	home.sessionVariables = {
		XCURSOR_THEME = cursorsThemeName;
		XCURSOR_SIZE = toString cursorSize;
	};
		
	gtk = {
		enable = true;
		font = {
			name = fontName;
			size = fontSize;
 		};
		theme = {
			name = gtkThemeName;
			package = gtkThemePkg;
		};
		iconTheme = {
			name = iconThemeName;
			package = iconThemePkg;
		};
		cursorTheme = {
			name = cursorsThemeName;
			package = cursorsThemePkg;
		};

		gtk3 = {
			extraConfig.gtk-application-prefer-dark-theme = true;
		};
		gtk4 = {
			extraConfig.gtk-application-prefer-dark-theme = true;
		};
	};

	dconf.settings = {
		"org/gnome/desktop/interface" = {
			gtk-theme = gtkThemeName;
			color-scheme = "prefer-dark";
		};

		# For Gnome shell
		# "org/gnome/shell/extensions/user-theme" = {
		# 	name = gtkThemeName;
		# };
	};
	
	qt = {
		enable = true;
		platformTheme.name = "gtk"; 
		style = {
			# name = gtkThemeName; # gtkThemeName;
			# package = pkgs.kdePackages.breeze;
		};
	};
};
}