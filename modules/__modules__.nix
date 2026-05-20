{ config, lib, ... }:
{
	options.modules.enable = lib.mkEnableOption "system modules";

	imports = [
		./development/__development__.nix
		./services/__services__.nix
		./shells/__shells__.nix
		./virtual/__virtual__.nix
		./utilities/__utilities__.nix
	];

	config = lib.mkMerge [
		{ modules.enable = lib.mkDefault true; }
		(lib.mkIf config.modules.enable {
			modules = lib.mkDefault {
				development.languages        = [ "c-cpp" "javascript" "python" "rust" ];
				services.enable              = true;
				services.audio.enable        = true;
				services.ssh.enable          = true;
				services.xserver.enable      = true;
				shells.enable                = true;
				shells.fish.enable           = true;
				shells.zsh.enable            = true;
				virtual.enable               = true;
				utilities.enable             = true;
				utilities.neovim.enable      = true;
				utilities.yazi.enable        = true;
				utilities.basic-tools.enable = true;
			};
		})
	];
}
