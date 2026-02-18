{ pkgs, username, ... }: 
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
home-manager.users.${username} = {
	home.packages = with pkgs; [
		flclash

		kdePackages.filelight
		gparted

		localsend
		# 编辑器
		imhex
		gimp2
		zed-editor
		obsidian
		libreoffice-qt

		# 录屏
		obs-studio
		showmethekey

		# 应用
		gearlever
		bottles

		# 其他
		pomodoro-gtk
		# keepassxc
	];
};

}
