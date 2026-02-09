{ pkgs, username, ... }:
{
	programs.labwc.enable = true;
	environment.systemPackages = with pkgs; [git
		# labwc #装这里不污染全局
		wlr-randr
	];#dbus-run-session labwc
	
	
	home-manager.users.${username} = {
		# 强制 GTK 应用显示：最小化、最大化、关闭
		dconf.settings = {
			"org/gnome/desktop/wm/preferences" = {
			button-layout = "appmenu:minimize,maximize,close";
			};
		};
		xdg.configFile = {
			"labwc/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
		home.file = {
		".local/share/themes/" = {
				source = ./themes;
				force = true;
				recursive = true;
			};
		};
	};
	
		
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
