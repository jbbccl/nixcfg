{ ... } : {
# List services that you want to enable:

# services.openssh.enable = true;	# Enable the OpenSSH daemon.

# services.printing.enable = true;	# 启用CUPS打印系统

# services.libinput.enable = true;	# 触摸板支持（桌面环境默认启用）
imports = [
	./ssh.nix
];

}
