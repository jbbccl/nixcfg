{ config, lib, pkgs, username, ... }:
let
	cfg = config.modules.virtual.container;
in
{
	options.modules.virtual.container.enable = lib.mkEnableOption "containers (podman + distrobox)";

	config = lib.mkIf cfg.enable {
		virtualisation = {
			containers.enable = true;
			podman = {
				enable = true;
				dockerCompat = true;
				defaultNetwork.settings.dns_enabled = true;
			};
		};

		users.users.${username}.extraGroups = [ "podman" ];

		home-manager.users.${username} = {
			xdg.configFile = {
				"containers/storage.conf" = {
					force = true;
					recursive = true;
					text = ''
						[storage]
						driver = "overlay"
						graphroot = "/home/VMS/docker/storage"
					'';
				};
			};
		};

		environment.systemPackages = with pkgs; [
			podman
			podman-compose
			distrobox
		];
	};
}
