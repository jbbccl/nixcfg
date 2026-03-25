{ config, pkgs, ... }:
{
	services.mihomo = {
		enable = true;
		configFile = "/etc/mihomo/config.yaml";
		webui = pkgs.metacubexd;
	};

	environment.etc = {
		"mihomo/config.yaml" = {
			source = ./etc/mihomo/config.yaml;
		};
	};
	# environment.systemPackages = with pkgs; [
	# 	dae
	# 	daed
	# ];

	# services.dae = {
	# 	enable = true;
	# 	config = '''';
	# };
}
