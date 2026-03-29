{ config, pkgs, username, ... }: {
imports = [
	./editTools/pdf.nix
	./neovim/neovim.nix
	./yazi/yazi.nix
];

environment.systemPackages = with pkgs; [
	vim
	git
	glib

	pciutils

	wget
	curl
	# dae

	ripgrep
	fd
	tree
	
	file
	_7zz-rar
	
	squashfsTools

	# xorg.xwininfo
	# xclip
	xeyes
];
programs.firejail.enable = true;

# 把包的 unit 暴露给 systemd
# systemd.packages = [ pkgs.dae ];
# systemd.services.dae = {
# 	description = "dae service";
# 	after = [ "network.target" ];
# 	wantedBy = [ "multi-user.target" ];
# 	# serviceConfig = {
# 	# 	Type = "simple";   # 或省略（默认simple）
# 	# 	ExecStart = "${pkgs.dae}/bin/dae";  # 这里只有一行
# 	# };
# };


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
