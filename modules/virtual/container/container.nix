{ config, pkgs, username, ... }:
{

virtualisation = {

	containers={
		enable = true;
		# storage.settings.storage = {
		# 	driver = "overlay";
		# 	graphroot = "/home/VMS/docker/storage";
		# 	runroot = "/home/VMS/docker/run";
		# };
	};
	
	waydroid.enable = true;
	# docker.enable = true;
	podman = {
		enable = true;
		dockerCompat = true;	# 启用 Docker 兼容
		defaultNetwork.settings.dns_enabled = true;
		# autoUpdate = true;
		# enableNvidia = config.hardware.nvidia.enable or false;
	};
};

users.users.${username}.extraGroups = [ "podman" ];

home-manager.users.${username} = {
	xdg.configFile = {
		"containers/storage.conf" = {
			force = true;
			recursive = true;
			text=''
[storage]
driver = "overlay"
graphroot = "/home/VMS/docker/storage"
#runroot = "/home/VMS/docker/run"
'';
		};
	};
};


environment.systemPackages = with pkgs; [
	podman
	podman-compose 
	distrobox
];

}