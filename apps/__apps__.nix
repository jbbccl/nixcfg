{ lib, helpers, ... }:
let
	inherit (helpers) mkNullOrEnum mkNullOrListEnum;
in {
	imports = [
		./services/__services__.nix
		./gui/__gui__.nix
		./cli/__cli__.nix
		./containers/__containers__.nix
	];

	options.apps = {
		gui.defaultBrowser = mkNullOrEnum "defaultBrowser" [ "chromium" "firefox" ];
		# services.enable = lib.mkEnableOption "application services (AI, proxy, remote)";
		# gui.enable = lib.mkEnableOption "GUI applications (terminal, browser, file manager)";
		# cli.enable = lib.mkEnableOption "CLI applications (misc tools)";
		containers.enable = lib.mkEnableOption "containers";
	};

	config = {
		apps.gui.defaultBrowser = "firefox" ;
		# apps.services.enable = lib.mkDefault true;
		# apps.gui.enable = lib.mkDefault true;
		# apps.cli.enable = lib.mkDefault true;
		apps.containers.enable = lib.mkDefault false;
	};
}
