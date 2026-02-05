{ pkgs, ... }: {
# services.xserver.enable = true;
services.displayManager.sddm = {
	enable = true;
	wayland.enable = true; 
	# ls -l /run/current-system/sw/share/sddm/themes/
	theme = "catppuccin-macchiato-mauve";
	
};
# catppuccin.sddm = {
# 	enable =true;
# 	flavor = "macchiato";
# 	font  = "Maple Mono NF CN";
# 	fontSize = "12";
# };

environment.systemPackages = [
	(pkgs.catppuccin-sddm.override {
		flavor = "macchiato"; 
		font  = "Maple Mono NF CN";
		fontSize = "12";
		loginBackground = false;
		# background = "${./wallpaper.png}"; 
	})
];
}