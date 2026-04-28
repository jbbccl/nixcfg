{ lib, ... }: {
	imports = [
		./services/__services__.nix
		./gui/__gui__.nix
		./cli/__cli__.nix
		./containers/daily/__daily__.nix
	];

	options.apps = {
		services = lib.mkEnableOption "application services (AI, proxy, remote)";
		gui = lib.mkEnableOption "GUI applications (terminal, browser, file manager)";
		cli = lib.mkEnableOption "CLI applications (misc tools)";
		containers = lib.mkEnableOption "containerized applications (daily containers)";
	};

	config = {
		apps.services = lib.mkDefault true;
		apps.gui = lib.mkDefault true;
		apps.cli = lib.mkDefault true;
		apps.containers = lib.mkDefault true;
		apps.daily-containers.enable = lib.mkDefault true;
		apps.daily-containers.debian.enable = lib.mkDefault true;
	};
}
