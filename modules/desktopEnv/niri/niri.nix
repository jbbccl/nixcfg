{ pkgs, username, ... }:
{
#将不和niri强绑定的分离，再import
programs.niri.enable = true;

security.polkit.enable = true; # polkit
services.gnome.gnome-keyring.enable = true; # secret service
security.pam.services.swaylock = {};

environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
	#fuzzel swaylock mako swayidle brightnessctl#亮度调节
	xwayland-satellite
	labwc
	xdg-desktop-portal-gnome
	xdg-desktop-portal-gtk
	wl-clipboard
];

# 1. 启用 XDG Desktop Portal (解决 Webview 和文件对话框卡顿的核心)
# xdg.portal = {
# 	enable = true;
# 	wlr.enable = true; # 为 wlroots 基于的合成器提供截屏/录屏支持
# 	# 必须安装一个 GTK 或 GNOME 的 portal 实现，
# 	# 即使你不用 GNOME，Thunar 和大多数 GUI 软件也依赖它来渲染文件选择框。
# 	extraPortals = [
# 		pkgs.xdg-desktop-portal-gtk
# 		pkgs.xdg-desktop-portal-gnome 
# 	];
# 	# 解决 portal 冲突配置 (NixOS 23.11+ 建议配置)
# 	config.common.default = "*";
# };


# 3. 确保安装了 Polkit 认证代理
# 某些软件启动时会检查权限，如果没有代理也会卡住。
# 这里以 KDE 的代理为例（因为你装了 Dolphin），也可以用 polkit-gnome
# environment.systemPackages = [
# 	pkgs.polkit-kde-agent
# ];
}
