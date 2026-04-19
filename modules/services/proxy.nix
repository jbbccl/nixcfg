{ config, pkgs, lib, ... }:
{

	sops.templates."mihomo-config.yaml" = {
		owner = "root";
		group = "root";
		mode = "640";

		content = lib.replaceStrings [
			"AIRPORT01_URL_PLACEHOLDER"
			"AIRPORT02_URL_PLACEHOLDER"
		] [
			config.sops.placeholder.airport01URL
			config.sops.placeholder.airport02URL
		] (builtins.readFile ./config/mihomo/config.yaml);
	};

	services.mihomo = {
		enable = true;
		configFile = config.sops.templates."mihomo-config.yaml".path;
		webui = pkgs.metacubexd;
		tunMode = true;
	};
}
