{ pkgs, username, ... }:
{
	programs.niri.enable = true;

	# environment.sessionVariables.NIXOS_OZONE_WL = "1";
	home-manager.users.${username} = {
		xdg.configFile = {
			"niri/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};

	environment.systemPackages = with pkgs; [
		# niri
		xwayland-satellite
		wl-clipboard
	];
}
