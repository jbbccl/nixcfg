{ lib, config, ... }: {
	options.apps = {
		services = lib.mkEnableOption "application services (AI, proxy, remote)";
		gui = lib.mkEnableOption "GUI applications (terminal, browser, file manager)";
		cli = lib.mkEnableOption "CLI applications (misc tools)";
	};

	imports = [
		(lib.mkIf config.apps.services ./services/__services__.nix)
		(lib.mkIf config.apps.gui ./gui/__gui__.nix)
		(lib.mkIf config.apps.cli ./cli/__cli__.nix)
	];
}
