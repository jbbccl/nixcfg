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

#部分网络设置位于network-time.nix
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

# Flatpak
services.flatpak.enable = true;
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install --user flathub com.usebottles.bottles

# AppImage
programs.appimage = {
	enable = true;
	binfmt = true;
};

environment.systemPackages = with pkgs; [
	podman
	podman-compose 
	# skopeo				# 容器镜像管理工具
	# buildah				# 构建容器镜像工具
	distrobox				# 容器化开发环境
	# docker-compose

	waydroid-nftables
	# nftables				#waydroid要用
];

}

# waydroid session start
# [00:21:58] RuntimeError: Command failed: % /nix/store/sxxwbc59lsip9shfp1ll7xhz5pcbk82m-waydroid-1.6.1/lib/waydroid/data/scripts/waydroid-net.sh start777