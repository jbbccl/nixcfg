{ pkgs, ... }: {
imports = [
	./neovim/neovim.nix

	./btop.nix
];

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
	(yazi.override {
		_7zz = _7zz-rar;  # Support for RAR extraction
	})
];
}
