{ config, lib, pkgs, username, ... }:
let
	opencodeWrapped = lib.mkIf config.secrets.available (pkgs.writeShellScriptBin "opencode" ''
		set -a
		source ${config.sops.secrets.api-key-env.path}
		set +a
		exec ${pkgs.opencode}/bin/opencode "$@"
	'');
in
{
	environment.systemPackages = [
		opencodeWrapped
	];

	home-manager.users.${username} = {
		xdg.configFile."opencode/opencode.json" = {
			source = ./opencode.json;
		};
	};
}