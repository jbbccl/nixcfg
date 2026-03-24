{ pkgs, username, ... }:
{
	environment.systemPackages = with pkgs; [
		fuzzel
		# wofi
		# walker
	];

	home-manager.users.${username} = {
		xdg.configFile = {
			"fuzzel/" = {
				force = true;
				recursive = true;
				source = ./fuzzel;
			};
		};
	};
}
