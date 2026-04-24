{ pkgs, config, lib, username, ... }:
let
	configFile = builtins.toFile "litellm-config.yaml" (builtins.readFile ./config.yaml);
in
{
	environment.systemPackages = [
		pkgs.litellm
	];

	systemd.user.services.litellm = {
		enable = true;
		description = "LiteLLM Proxy (user mode)";
		after = [ "network.target" ];

		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.litellm}/bin/litellm --host 127.0.0.1 --port 4010 --config ${configFile}";
			Restart = "always";
			RestartSec = "5";
			EnvironmentFile = config.sops.secrets.litellm-env.path;
		};
	};
}
