{ username, ... }:{

	programs.mango.enable = true;
	# home-manager.users.${username} = {
	# 	xdg.configFile = {
	# 		"niri/" = {
	# 			force = true;
	# 			recursive = true;
	# 			source = ./config;
	# 		};
	# 	};
	# };
}