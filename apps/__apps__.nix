{ lib, ... }: {
	options.apps = {
		services = lib.mkEnableOption "application services (AI, proxy, remote)";
		gui = lib.mkEnableOption "GUI applications (terminal, browser, file manager)";
		cli = lib.mkEnableOption "CLI applications (misc tools)";
	};

	imports = [
		./services/__services__.nix
		./gui/__gui__.nix
		./cli/__cli__.nix
	];

	config = {
		apps.services = lib.mkDefault true;
		apps.gui = lib.mkDefault true;
		apps.cli = lib.mkDefault true;
	};
}
