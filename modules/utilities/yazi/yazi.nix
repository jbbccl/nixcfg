{ username, pkgs, ... }:{

	environment.systemPackages = with pkgs; [
		(yazi.override {
			_7zz = _7zz-rar; 
		})
	];

	home-manager.users.${username} = {
		# home.packages = with pkgs; [
		# 	(yazi.override {
		# 		_7zz = _7zz-rar; 
		# 	})
		# ];
		
		xdg.configFile = {
			"yazi/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};
}