xdg.portal = {
	enable = true;
	wlr.enable = true;

	extraPortals = with pkgs; [
		xdg-desktop-portal-wlr
		xdg-desktop-portal-gtk
		xdg-desktop-portal-gnome
		xdg-desktop-portal-hyprland
	];

	config = {
		# ── labwc ──
		# labwc 是 wlroots 合成器，使用 wlr portal
		labwc = {
			default = [ "wlr" "gtk" ];
			"org.freedesktop.impl.portal.Screenshot" = "wlr";
			"org.freedesktop.impl.portal.ScreenCast" = "wlr";
			"org.freedesktop.impl.portal.FileChooser" = "gtk";
			"org.freedesktop.impl.portal.AppChooser" = "gtk";
		};

		# ── niri ──
		# niri 也是 wlroots 风格，使用 gnome portal 体验更好
		# （niri 官方推荐 gnome portal，因为它与 GNOME 生态集成良好）
		niri = {
			default = [ "gnome" "gtk" ];
			"org.freedesktop.impl.portal.Screenshot" = "gnome";
			"org.freedesktop.impl.portal.ScreenCast" = "gnome";
			"org.freedesktop.impl.portal.FileChooser" = "gtk";
			"org.freedesktop.impl.portal.AppChooser" = "gtk";
			"org.freedesktop.impl.portal.Inhibit" = "gnome";
			"org.freedesktop.impl.portal.Access" = "gtk";
		};

		# ── Hyprland ──
		# Hyprland 有自己专属的 portal
		hyprland = {
			default = [ "hyprland" "gtk" ];
			"org.freedesktop.impl.portal.Screenshot" = "hyprland";
			"org.freedesktop.impl.portal.ScreenCast" = "hyprland";
			"org.freedesktop.impl.portal.FileChooser" = "gtk";
			"org.freedesktop.impl.portal.AppChooser" = "gtk";
			"org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
		};

		# ── 通用兜底 ──
		# 如果桌面环境变量未被识别，使用 gtk 作为 fallback
		common = {
			default = [ "gtk" ];
		};
	};
};
