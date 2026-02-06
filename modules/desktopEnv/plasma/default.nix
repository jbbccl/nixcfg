{ ... } : {
	services.xserver.enable = true;  # 启用X11窗口系统
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
  # iservices.desktopManager.gnome.enable = true;  # 启用GNOME桌面环境
  # services.displayManager.gdm.enable = true;  # 启用GDM显示管理器（GNOME登录界面）

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";
}
