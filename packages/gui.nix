{ pkgs, username, ... }: {
home-manager.users.${username} = {
	home.packages = with pkgs; [
		clash-verge-rev
		kdePackages.filelight
		localsend
		# obsidian
		gparted
		zed-editor
		# libreoffice-qt
		# hunspell
		# wpsoffice-cn
		# hunspellDicts.zh_CN
	];
};

}
