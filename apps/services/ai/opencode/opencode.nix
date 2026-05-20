{ config, lib, pkgs, username, ... }:
let
	cfg = config.apps.services.ai.opencode;
	opencodeWrapped = pkgs.writeShellScriptBin "opencode" ''
		set -a
		source ${config.sops.secrets.api-key-env.path}
		set +a
		exec ${pkgs.opencode}/bin/opencode "$@"
	'';
in
{
	options.apps.services.ai.opencode.enable = lib.mkEnableOption "opencode CLI";

	config = lib.mkIf cfg.enable {
		environment.systemPackages = [
			opencodeWrapped
		];

		home-manager.users.${username} = {
			xdg.configFile."opencode/opencode.json" = {
				source = ./opencode.json;
			};
		};
	};
}
