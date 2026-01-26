{ pkgs, ... }: {
environment.systemPackages = with pkgs; [
	vim
	git
	pciutils
	wget
	curl
	ripgrep
	fzf
	fd
	tree
	btop
	yazi
];
}
