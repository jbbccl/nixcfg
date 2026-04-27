{ username, ... }: {
	time.timeZone = "Asia/Shanghai";
	i18n.defaultLocale = "zh_CN.UTF-8";

	nix.settings = {
		substituters = [
			"https://mirrors.ustc.edu.cn/nix-channels/store?priority=5"
			"https://cache.nixos.org/"
		];
		experimental-features = [ "nix-command" "flakes" ];
		max-jobs = "auto";
		cores = 0;
		auto-optimise-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "03:15";
		options = "--delete-older-than 7d";
	};

	documentation.enable = false;

	security.sudo = {
		enable = true;

		extraConfig = ''
			Defaults env_keep += "http_proxy https_proxy ftp_proxy rsync_proxy all_proxy"
			Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY"
		'';
		
		extraRules = [{                                                       
			users = [ "${username}" ];                                                                  
			commands = [{                                                                     
			command = "/run/current-system/sw/bin/podman";                                  
			options = [ "NOPASSWD" ];                                                       
			}];                                                                               
		}];
	};
}
