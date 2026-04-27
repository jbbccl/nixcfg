{ lib, ... }: {
	options.modules = {
		services = lib.mkEnableOption "system services (audio, networking, ssh)";
		development = lib.mkEnableOption "development tooling (git, languages)";
		shells = lib.mkEnableOption "shell configurations (zsh, fish, bash)";
		virtualization = lib.mkEnableOption "virtualization (KVM, containers, appimage)";
		utilities = lib.mkEnableOption "utilities (neovim, yazi, basic tools)";
	};

	imports = [
		./development/__development__.nix
		./services/__services__.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];

	config = {
		modules.services = lib.mkDefault true;
		modules.development = lib.mkDefault true;
		modules.shells = lib.mkDefault true;
		modules.virtualization = lib.mkDefault true;
		modules.utilities = lib.mkDefault true;
	};
}
