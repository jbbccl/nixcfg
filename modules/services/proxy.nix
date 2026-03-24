{ config, pkgs, ... }:
{
	services.mihomo = {
		enable = true;
		configFile = "/path/to/config.yaml";
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
