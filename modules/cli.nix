{ pkgs, ... }: {
environment.systemPackages = with pkgs; [
	fzf
	vim
	git
	wget
	curl
	tree
	ripgrep
	fd
	btop
	yazi
];
}
