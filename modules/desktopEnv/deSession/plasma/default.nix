{ pkgs, ... } : {
	services = {
		desktopManager.plasma6.enable = true;
		# displayManager.sddm.enable = true;
		# displayManager.sddm.wayland.enable = true;
		# xserver.enable = true;
	};

	# services.desktopManager.plasma6.enable = true;
	# programs.plasma.enable = true;
	environment.plasma6.excludePackages = with pkgs; [
		kdePackages.elisa # Simple music player aiming to provide a nice experience for its users
		kdePackages.kdepim-runtime # Akonadi agents and resources
		kdePackages.kmahjongg # KMahjongg is a tile matching game for one or two players
		kdePackages.kmines # KMines is the classic Minesweeper game
		kdePackages.konversation # User-friendly and fully-featured IRC client
		kdePackages.kpat # KPatience offers a selection of solitaire card games
		kdePackages.ksudoku # KSudoku is a logic-based symbol placement puzzle
		kdePackages.ktorrent # Powerful BitTorrent client
		mpv
	];

  # services.desktopManager.gnome.enable = true;  # 启用GNOME桌面环境
  # services.displayManager.gdm.enable = true;  # 启用GDM显示管理器（GNOME登录界面）
}
