{ config, lib, pkgs, ... }:
let
	browser = "librewolf.desktop";
in {
	# programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
		ungoogled-chromium
		# librewolf
		floorp-bin
	];
	# xdg.mime.defaultApplications = {
	# 	"text/html" = browser;
	# 	"x-scheme-handler/http" = browser;
	# 	"x-scheme-handler/https" = browser;
	# 	"x-scheme-handler/about" = browser;
	# 	"x-scheme-handler/unknown" = browser;
	# };
}
