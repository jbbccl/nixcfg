{ config, lib, pkgs, ... }:
let
	browser = "librewolf.desktop";
in {
	programs.firefox.enable = true;	# 15
	environment.systemPackages = with pkgs; [
		# ungoogled-chromium	# 20
		brave		# 25
		# librewolf
		# floorp-bin	# 11.5
	];
	# xdg.mime.defaultApplications = {
	# 	"text/html" = browser;
	# 	"x-scheme-handler/http" = browser;
	# 	"x-scheme-handler/https" = browser;
	# 	"x-scheme-handler/about" = browser;
	# 	"x-scheme-handler/unknown" = browser;
	# };
}
