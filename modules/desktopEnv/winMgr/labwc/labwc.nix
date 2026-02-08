{ pkgs, username, ... }:
{
	environment.systemPackages = with pkgs; [git
		labwc
		wlr-randr
	];#dbus-run-session labwc
	  # 强制 GTK 应用显示：最小化、最大化、关闭
	home-manager.users.${username} = {
		dconf.settings = {
			"org/gnome/desktop/wm/preferences" = {
			button-layout = "appmenu:minimize,maximize,close";
			};
		};
	};
	# TODO 配置文件
}
