{ config, lib, pkgs, username, ... }:
{
	options.modules.shells.fish.enable = lib.mkEnableOption "fish shell";

	config = lib.mkIf config.modules.shells.fish.enable {

        programs.fish = {
            enable = true;
            shellInit = ''
                function nix-shell --wraps nix-shell
                command nix-shell --command "exec fish" $argv
                end
            '';
        };

		home-manager.users.${username} = {
			programs.fish = {
                enable = true;
                plugins = [
                    {
                    name = "fzf-fish";
                    src = pkgs.fishPlugins.fzf-fish.src;
                    }
                ];

                interactiveShellInit = ''
                    # 全局 fzf 默认选项
                    set -gx FZF_DEFAULT_OPTS '--height 60% --border --info=inline --prompt="➜ "'
                    # 配置 key bindings
                    fzf_configure_bindings --directory=\ct --history=\cr --processes=\ck --variables=\cv
                '';
            };

			xdg.configFile."fish/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};
}
