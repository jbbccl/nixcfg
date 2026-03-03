{ ... }:
{
services.xserver = {
	xkb = {
		layout = "us";  # 或其他布局
		options = "caps:swapescape"; # 交换 CapsLock 和 Escape
		};
	};
# console.useXkbConfig = true;
# List services that you want to enable:

# services.openssh.enable = true;	# Enable the OpenSSH daemon.

# services.printing.enable = true;	# 启用CUPS打印系统

# services.libinput.enable = true;	# 触摸板支持（桌面环境默认启用）
}
