{ config, lib, pkgs, ... }:
let
	browser = if config.apps.gui.defaultBrowser or "chromium" == "firefox" then "firefox.desktop" else "chromium-browser.desktop";
in {
	programs.firefox.enable = true;
	environment.systemPackages = with pkgs; [
		ungoogled-chromium
	];
	xdg.mime.defaultApplications = {
		"text/html" = browser;
		"x-scheme-handler/http" = browser;
		"x-scheme-handler/https" = browser;
		"x-scheme-handler/about" = browser;
		"x-scheme-handler/unknown" = browser;
	};
}
