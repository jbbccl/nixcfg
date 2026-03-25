{ config, pkgs, username, ... }:
{
	services.mihomo = {
		enable = true;
		#先这样吧
		configFile = "/home/${username}/nixrc/static/_security/mihomo/config.yaml";
		webui = pkgs.metacubexd;
	};

	# environment.etc = {
	# 	"mihomo/config.yaml" = {
	# 		source = ./etc/mihomo/config.yaml;
	# 	};
	# };
	# environment.systemPackages = with pkgs; [
	# 	dae
	# 	daed
	# ];

	# services.dae = {
	# 	enable = true;
	# 	config = '''';
	# };
}
