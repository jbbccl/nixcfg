{ lib, ... }: {
	imports = [
		./development/__development__.nix
		./services/__services__.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];

	# 这些 options 只是定义了, 并没有使用
	options.modules = {
		# services.enable = lib.mkEnableOption "system services (audio, networking, ssh)";
		development.enable = lib.mkEnableOption "development tooling (git, languages)";
		# shells.enable = lib.mkEnableOption "shell configurations (zsh, fish, bash)";
		# virtualization.enable = lib.mkEnableOption "virtualization (KVM, containers, appimage)";
		# utilities.enable = lib.mkEnableOption "utilities (neovim, yazi, basic tools)";
	};

	config = {
		# modules.services.enable = lib.mkDefault true;
		modules.development.enable = lib.mkDefault true;
		# modules.shells.enable = lib.mkDefault true;
		# modules.virtualization.enable = lib.mkDefault true;
		# modules.utilities.enable = lib.mkDefault true;
	};
}
