{ lib, config, username, self, ... }:{
	imports = [
		./litellm/litellm.nix
		./hermes/hermes.nix
		./opencode/opencode.nix
	];

	sops.secrets = lib.mkIf config.secrets.available {
		api-key-env = {
			sopsFile = "${self}/secrets/api_keys.yaml";
			owner = "${username}";
			group = "users";
			mode = "0400";
		};
	};
}
