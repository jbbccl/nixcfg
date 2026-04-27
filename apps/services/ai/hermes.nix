{ config, lib, pkgs, username, ... }:
{
	services.hermes-agent = lib.mkIf config.secrets.available{
		enable = true;

		addToSystemPackages = true;
		container = {
			enable = true;

			backend = "podman";
			hostUsers = [ "${username}" ];
			
			 extraVolumes = [
				"/home/${username}:/home/${username}"
			];
		};

		settings = {
			model = {
				default = "deepseek-v4-pro";
				base_url = "https://api.deepseek.com";
			};
			toolsets = [ "all" ];
			terminal = { backend = "local"; timeout = 180; };
			display = { compact = false; personality = "kawaii"; };
			memory = { memory_enabled = true; user_profile_enabled = true; };
		};

		environmentFiles = [ config.sops.secrets.hermes-env.path ];
	};
}
