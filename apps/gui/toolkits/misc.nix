{ pkgs, username, ... }:
let
#   myClashVerge = pkgs.callPackage ./clash-verge/package.nix { };
in
{
	environment.systemPackages = with pkgs; [
		kdePackages.partitionmanager
	];

	home-manager.users.${username} = {
		home.packages = with pkgs; [
			# flclash
			# daed

			kdePackages.filelight
			# gparted
			# partitionmanager

			localsend

			# 编辑器
			imhex
			gimp
			zed-editor
			# obsidian
			libreoffice-qt

			# 流
			obs-studio
			showmethekey
			moonlight-qt
			vlc

			# 应用
			gearlever
			# bottles

			# 其他
			pomodoro-gtk
			# keepassxc
			xeyes
		];
	};
}
