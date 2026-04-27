{ lib, config, ... }: {
	options.modules = {
		services = lib.mkEnableOption "system services (audio, networking, ssh)";
		development = lib.mkEnableOption "development tooling (git, languages)";
		shells = lib.mkEnableOption "shell configurations (zsh, fish, bash)";
		virtualization = lib.mkEnableOption "virtualization (KVM, containers, appimage)";
		utilities = lib.mkEnableOption "utilities (neovim, yazi, basic tools)";
	};

	imports = [
		(lib.mkIf config.modules.services ./services/__services__.nix)
		(lib.mkIf config.modules.development ./development/__development__.nix)
		(lib.mkIf config.modules.shells ./shells/__shells__.nix)
		(lib.mkIf config.modules.virtualization ./virtual/__virtual__.nix)
		(lib.mkIf config.modules.utilities ./utilities/__utilities__.nix)
	];
}
