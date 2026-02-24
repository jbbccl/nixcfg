{config, username, ...}:{

	time.timeZone = "Asia/Shanghai";

	nix.settings = {
		substituters = [
			"https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=1"
			"https://mirrors.ustc.edu.cn/nix-channels/store?priority=5"
			"https://cache.nixos.org/"  # 默认官方缓存
			#export NIX_PATH=nixpkgs=https://cache.nixos.org/
		];
		experimental-features = [ "nix-command" "flakes" ];
	};


	networking = {
		hostName = "nixos";
		networkmanager.enable = true;
		# networkmanager.wifi.powersave = false;
		# 启用这个解决 waydroid-net.sh 报错
		nftables.enable = true;
		firewall = {
			enable = true;
			allowedTCPPorts = [
				53317
			];
			trustedInterfaces = [ "waydroid0" "virbr0" ];
			# allowedUDPPorts = [ ... ];
		};

		# proxy = {
		# 	default = "http://user:password@proxy:port/";
		# 	"127.0.0.1,localhost,internal.domain";
		# };

	};
	users.users.${username}.extraGroups = [ "networkmanager" ];

	security.sudo = {
		enable = true;
		# 将代理变量添加到保留环境变量列表中
		extraConfig = ''
			Defaults env_keep += "http_proxy https_proxy ftp_proxy rsync_proxy all_proxy"
			Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY"
			#includedir /etc/sudoers.d
		'';
	};
	#waydroid需要networking.firewall.
	boot.kernel.sysctl = {
		"net.ipv4.ip_forward" = 1;
		"net.ipv4.conf.all.forwarding" = 1;
		# "net.ipv6.conf.all.forwarding" = 1;
	};
	# environment.etc = {
	# 	"sudoers.d/proxy_env" = {
	# 	text = ''
	# 		Defaults env_keep += "http_proxy HTTP_PROXY https_proxy HTTPS_PROXY"
	# 		Defaults env_keep += "ftp_proxy FTP_PROXY ALL_PROXY all_proxy"
	# 		Defaults env_keep += "NIX_PATH"  # 如果你也需要 NIX_PATH
	# 	'';
	# 	mode = "0440";  # 权限
	# 	};
	# };

	# 一些需要 SUID 包装的程序，可进一步配置或在用户会话中启动
	# programs.mtr.enable = true;	# 网络诊断工具
	# programs.gnupg.agent = {	# GnuPG 代理
	# 	enable = true;
	# 	enableSSHSupport = true;	 # 启用 SSH 支持
	# };
}
