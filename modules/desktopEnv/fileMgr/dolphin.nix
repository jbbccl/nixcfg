{ config, pkgs, ... }:

{
  # 1. 安装关键的 KDE 依赖和 GNOME 菜单定义
  environment.systemPackages = with pkgs; [
    kdePackages.kded         # 核心修复：提供 SolidUiServer (挂载弹窗)
    kdePackages.kio-extras   # 核心修复：提供 smb, mtp 等挂载协议支持
    gnome-menus              # 核心修复：借用 GNOME 的菜单结构文件
    
    # 其他可能需要的辅助工具
    kdePackages.kservice     # 提供 kbuildsycoca6 命令
    shared-mime-info         # 修复文件类型识别

	kdePackages.kio # needed since 25.11
	kdePackages.kio-fuse #to mount remote filesystems via FUSE
	kdePackages.qtsvg
	kdePackages.kservice
	kdePackages.dolphin
	xdg-utils        # 修复 xdg-open
	kdePackages.kservice # 关键：用于构建应用菜单缓存
  ];

  # 2. 注册 KDED 到 D-Bus (解决 "ServiceUnknown" 错误)
  # 这样当 Dolphin 呼叫 SolidUiServer 时，系统会自动拉起 kded6
  services.dbus.packages = [ pkgs.kdePackages.kded ];

  # 3. 解决 "applications.menu not found"
  # 告诉 KDE 使用 GNOME 提供的菜单定义 (因为我们安装了 gnome-menus)
  environment.sessionVariables = {
    XDG_MENU_PREFIX = "gnome-"; 
  };
  
  # 4. 确保应用目录被正确链接 (双重保险)
  environment.pathsToLink = [ "/share/applications" ];
}