{ self, pkgs, config, lib, username, ... }:
let
	configFile = builtins.toFile "litellm-config.yaml" (builtins.readFile ./config.yaml);
in
{
	environment.systemPackages = [
		pkgs.litellm
	];

	sops.secrets = lib.mkIf config.secrets.available {
		api-key-env = {
			sopsFile = "${self}/secrets/api_keys.yaml";
			owner = "${username}";
			group = "users";
			mode = "0400";
		};
	};

	systemd.user.services.litellm = lib.mkIf config.secrets.available {
		enable = true;
		description = "LiteLLM Proxy (user mode)";
		after = [ "network.target" ];

		serviceConfig = {
			Type = "simple";
			ExecStart = "${pkgs.litellm}/bin/litellm --host 127.0.0.1 --port 4010 --config ${configFile}";
			Restart = "always";
			RestartSec = "5";
			EnvironmentFile = config.sops.secrets.api-key-env.path;
		};
	};
}
