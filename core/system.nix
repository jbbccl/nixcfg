{ username, ... }: {
	time.timeZone = "Asia/Shanghai";

	nix.settings = {
		substituters = [
			"https://mirrors.ustc.edu.cn/nix-channels/store?priority=5"
			"https://cache.nixos.org/"
		];
		experimental-features = [ "nix-command" "flakes" ];
	};

	security.sudo = {
		enable = true;
		extraConfig = ''
			Defaults env_keep += "http_proxy https_proxy ftp_proxy rsync_proxy all_proxy"
			Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY"
		'';
	};
}
