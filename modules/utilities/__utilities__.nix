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
];

home-manager.users.${username} = {
	home.packages = with pkgs; [
		btop
		fzf
	];

	# catppuccin.flavor = "macchiato";
	# catppuccin.yazi.enable = true;
	# catppuccin.btop.enable = true;
};


}
