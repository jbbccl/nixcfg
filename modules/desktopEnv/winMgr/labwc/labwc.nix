{ pkgs, username, ... }:
{
	programs.labwc.enable = true;
	environment.systemPackages = with pkgs; [git
		# labwc #装这里不污染全局
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
	
	#在autostart启动下面服务
	systemd.user.targets.labwc-session = {
		description = "Labwc Compositor Session";
		documentation = [ "man:systemd.special(7)" ];
		
		# 当启动 labwc-session 时，它会尝试启动 graphical-session
		bindsTo = [ "graphical-session.target" ];
		wants = [ "graphical-session.target" ];
		after = [ "graphical-session.target" ];
	};
}
