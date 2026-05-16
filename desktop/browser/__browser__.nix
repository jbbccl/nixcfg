{ config, lib, pkgs, ... }:
let
	browser = "librewolf.desktop";
in {
	options.desktop.browser.firefox = {
		enable = lib.mkEnableOption "BetterFox privacy & performance tweaks for Firefox";
		smoothfox = lib.mkEnableOption "Smoothfox (Edge-like smooth scrolling, 90hz+)";
		searchEngines = lib.mkEnableOption "clean up bundled search engines (Amazon, eBay, Perplexity) and set DuckDuckGo as default";
		ublock = lib.mkEnableOption "auto-install uBlock Origin via enterprise policy";
	};

	imports = [
		./firefox.nix
		./other.nix
	];

	config = {
		
		desktop.browser.firefox = lib.mkIf config.desktop.enable {
			enable = true;
			smoothfox = true;
			searchEngines = true;
			ublock = true;
		};

		# xdg.mime.defaultApplications = {
		# 	"text/html" = browser;
		# 	"x-scheme-handler/http" = browser;
		# 	"x-scheme-handler/https" = browser;
		# 	"x-scheme-handler/about" = browser;
		# 	"x-scheme-handler/unknown" = browser;
		# };
	};
}
