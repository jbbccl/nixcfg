{ config, lib, pkgs, username, ... }:
{
	options.modules.utilities.yazi.enable = lib.mkEnableOption "yazi file manager";

	config = lib.mkIf config.modules.utilities.yazi.enable {
		environment.systemPackages = with pkgs; [
			(yazi.override {
				_7zz = _7zz-rar;
			})
		];
		home-manager.users.${username} = {
			xdg.configFile."yazi/" = {
				force = true;
				recursive = true;
				source = ./config;
			};
		};
	};
}
