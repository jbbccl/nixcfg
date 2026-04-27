{ config, lib, pkgs, username, ... }:
let
  cfg = config.services.hermes-agent;
in
{
	services.hermes-agent = lib.mkIf config.secrets.available {
		enable = true;

		addToSystemPackages = true;
		container = {
			enable = true;

			backend = "podman";
			hostUsers = [ "${username}" ];
			
			 extraVolumes = [
				"/home/${username}/nixcfg:/home/${username}/nixcfg:rw"
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

	# ── Seamless mode switching ─────────────────────────────────────────
	system.activationScripts."hermes-agent-fix-ownership" = lib.stringAfter [ "hermes-agent-setup" ] ''
		echo "hermes-agent: fixing ownership of state directory..."
		chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir} 2>/dev/null || true
		chmod 2770 ${cfg.stateDir} ${cfg.stateDir}/.hermes ${cfg.workingDirectory} 2>/dev/null || true
		chmod 0750 ${cfg.stateDir}/home 2>/dev/null || true

		for _d in cron sessions logs memories; do
			if [ -d "${cfg.stateDir}/.hermes/$_d" ]; then
				chmod 2770 "${cfg.stateDir}/.hermes/$_d" 2>/dev/null || true
			fi
		done
	'';

	system.activationScripts."hermes-agent-cleanup-container" = lib.mkIf (!cfg.container.enable) (lib.stringAfter [ "hermes-agent-fix-ownership" ] ''
		if ${pkgs.podman}/bin/podman container exists hermes-agent 2>/dev/null; then
			echo "hermes-agent: removing stale container from previous container mode..."
			${pkgs.podman}/bin/podman stop -t 10 hermes-agent 2>/dev/null || true
			${pkgs.podman}/bin/podman rm -f hermes-agent 2>/dev/null || true
		fi
	'');
}
