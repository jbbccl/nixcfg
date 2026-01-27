{ pkgs, username, ... }: {
home-manager.users.${username} = {
	home.packages = with pkgs; [
		clash-verge-rev

		kdePackages.filelight
		gparted

		localsend

		zed-editor
		obsidian
		libreoffice-qt
		# hunspell
		# wpsoffice-cn
		# hunspellDicts.zh_CN
	];
};

}
