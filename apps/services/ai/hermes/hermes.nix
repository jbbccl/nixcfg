{ config, lib, pkgs, username, ... }:
let
	cfg = config.services.hermes-agent;
	uid = builtins.toString config.users.users.${username}.uid;
in
{
	services.hermes-agent = lib.mkIf config.secrets.available {
		enable = true;

		addToSystemPackages = true;
		container = {
			enable = true;

			backend = "podman";
			image = "debian:bookworm-slim";
			hostUsers = [ "${username}" ];
			
			extraVolumes = [
				"/home/${username}/nixcfg:/home/${username}/nixcfg:rw"
				"/home/${username}/Desktop:/home/${username}/Desktop:rw"
				"/run/user/${uid}/podman/podman.sock:/run/user/${uid}/podman/podman.sock:rw"
			];
		};

		workingDirectory = "/home/hermes";

		configFile = ./config.yaml;

		# settings = {
		# 	model = {
		# 		default = "deepseek-v4-pro";
		# 		base_url = "https://api.deepseek.com";
		# 	};

		# 	providers = {
		# 		deepseek = {
		# 			api = "https://api.deepseek.com/v1";
		# 			key_env = "DEEPSEEK_API_KEY";
		# 			models = {
		# 				"deepseek-v4-pro" = {};
		# 				"deepseek-v4-flash" = {};
		# 			};
		# 		};
		# 		minimax = {
		# 			api = "https://api.minimaxi.com/v1";
		# 			key_env = "MINIMAX_API_KEY";
		# 			models = {
		# 				"minimax-M2.7" = {};
		# 			};
		# 		};
		# 	};

		# 	delegation = {
		# 		model = "deepseek-v4-flash";
		# 		base_url = "https://api.deepseek.com/v1";
		# 	};

		# 	auxiliary = {
		# 		compression = { model = "deepseek-v4-flash"; base_url = "https://api.deepseek.com/v1"; };
		# 		vision = { model = "deepseek-v4-flash"; base_url = "https://api.deepseek.com/v1"; };
		# 		session_search = { model = "deepseek-v4-flash"; base_url = "https://api.deepseek.com/v1"; };
		# 		approval = { model = "deepseek-v4-flash"; base_url = "https://api.deepseek.com/v1"; };
		# 		title_generation = { model = "deepseek-v4-flash"; base_url = "https://api.deepseek.com/v1"; };
		# 	};
		# 	toolsets = [ "all" ];
		# 	terminal = { backend = "local"; timeout = 180; };
		# 	display = { compact = false; personality = "kawaii"; };
		# 	memory = { memory_enabled = true; user_profile_enabled = true; };
		# };

		environmentFiles = [ config.sops.secrets.api-key-env.path ];
	};




	# system.activationScripts."hermes-agent-fix-ownership" = lib.stringAfter [ "hermes-agent-setup" ] ''
	# 	echo "hermes-agent: fixing ownership of state directory..."
	# 	chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir} 2>/dev/null || true
	# 	chmod 2770 ${cfg.stateDir} ${cfg.stateDir}/.hermes ${cfg.workingDirectory} 2>/dev/null || true
	# 	chmod 0440 ${cfg.stateDir}/.hermes/.env
	# 	chmod 0770 ${cfg.stateDir}/.hermes/config.yaml
	# 	chmod 0750 ${cfg.stateDir}/home 2>/dev/null || true

	# 	for _d in cron sessions logs memories; do
	# 		if [ -d "${cfg.stateDir}/.hermes/$_d" ]; then
	# 			chmod 2770 "${cfg.stateDir}/.hermes/$_d" 2>/dev/null || true
	# 		fi
	# 	done
	# '';

	# system.activationScripts."hermes-agent-cleanup-container" = lib.mkIf (!cfg.container.enable) (lib.stringAfter [ "hermes-agent-fix-ownership" ] ''
	# 	if ${pkgs.podman}/bin/podman container exists hermes-agent 2>/dev/null; then
	# 		echo "hermes-agent: removing stale container from previous container mode..."
	# 		${pkgs.podman}/bin/podman stop -t 10 hermes-agent 2>/dev/null || true
	# 		${pkgs.podman}/bin/podman rm -f hermes-agent 2>/dev/null || true
	# 	fi
	# '');
}
