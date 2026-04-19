{ config, pkgs, username, ... }:
let
	fullTemplate = builtins.readFile config/mihomo/config.yaml;
	airport01URL = "1111";
	airport02URL = "1111";
	# airport02URL = builtins.readFile config.age.secrets.airport_2.path;

	cleanURL = url: builtins.replaceStrings ["\n" "\r"] ["" ""] url;

	replacedTemplate = builtins.replaceStrings [
		"AIRPORT01_URL_PLACEHOLDER"
		"AIRPORT02_URL_PLACEHOLDER"
	] [
		(cleanURL airport01URL)
		(cleanURL airport02URL)
	] fullTemplate;

	finalConfig = pkgs.writeText "mihomo-config.yaml" replacedTemplate;
in
{
	services.mihomo = {
		enable = true;
		configFile = finalConfig;
		webui = pkgs.metacubexd;
		tunMode = true;
	};
}
