{ pkgs, username, ... }:{
	environment.systemPackages = with pkgs; [
		wayvnc
		novnc
		wlr-randr
		#sunshine
	];
	home-manager.users.${username} = {
		xdg.configFile = {
			"wayvnc/config" = {
				source = ./config/wayvnc/config;
			};
		};
	};
}
