{ config, pkgs, username, ... }:{
	programs.firejail.enable = true;
	
	environment.systemPackages = with pkgs; [
		glib

		vim

		wget curl
		pciutils

		ripgrep
		fd fzf
		tree # gettext

		file
		_7zz-rar

		# xclip
		nmap
	];
}