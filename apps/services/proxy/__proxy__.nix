{ config, pkgs, lib, ... }:
let
	template = builtins.readFile ./mihomo/config.yaml;
in
{
	services.mihomo = lib.mkIf config.secrets.available {
		enable = true;
		configFile = config.sops.templates."mihomo-config.yaml".path; # "/etc/mihomo/config.yaml"; #
		webui = pkgs.metacubexd;
		tunMode = true;
	};

	sops.templates."mihomo-config.yaml" = lib.mkIf config.secrets.available {
		owner = "root";
		group = "root";
		mode = "640";

		content = lib.replaceStrings [
			"AIRPORT01_URL_PLACEHOLDER"
			"AIRPORT02_URL_PLACEHOLDER"
			"AIRPORT03_URL_PLACEHOLDER"
		] [
			config.sops.placeholder.airport01URL
			config.sops.placeholder.airport02URL
			config.sops.placeholder.airport03URL
		] (template);
	};
}
