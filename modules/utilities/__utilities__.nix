{ pkgs,username, ... }: {
imports = [
	# ./neovim/neovim.nix
	./yazi/yazi.nix
];

environment.systemPackages = with pkgs; [
	vim
	git

	pciutils

	wget
	curl

	ripgrep
	fd
	tree

	squashfsTools

	# xorg.xwininfo
	# xclip
	xeyes
];
programs.firejail.enable = true;


home-manager.users.${username} = {
	home.packages = with pkgs; [
		fastfetch
		btop
		fzf
	];

	# catppuccin.flavor = "macchiato";
	# catppuccin.yazi.enable = true;
	# catppuccin.btop.enable = true;
};


}
