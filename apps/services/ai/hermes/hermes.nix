{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.services.ai.hermes;
  agentCfg = config.services.hermes-agent;
  uid = builtins.toString config.users.users.${username}.uid;
in {
  options.apps.services.ai.hermes.enable = lib.mkEnableOption "hermes-agent (container mode)";

  config = lib.mkIf cfg.enable {
    # users.users.${username}.linger = true;
    services.hermes-agent = {
      enable = true;

      addToSystemPackages = true;
      container = {
        enable = true;

        backend = "podman";
        image = "debian:bookworm-slim";
        hostUsers = ["${username}"];

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
      # };
      environmentFiles = [config.sops.secrets.api-key-env.path];
    };

    systemd.services.hermes-agent = {
      after = ["user@${uid}.service"];
      requires = ["user@${uid}.service"];
      unitConfig.Wants = lib.mkForce "";
    };

    system.activationScripts."hermes-agent-fix-ownership" = lib.stringAfter ["hermes-agent-setup"] ''
      echo "hermes-agent: fixing ownership of state directory..."
      chown -R ${agentCfg.user}:${agentCfg.group} ${agentCfg.stateDir} 2>/dev/null || true
      chmod 2770 ${agentCfg.stateDir} ${agentCfg.stateDir}/.hermes ${agentCfg.workingDirectory} 2>/dev/null || true
      chmod 0440 ${agentCfg.stateDir}/.hermes/.env
      chmod 0770 ${agentCfg.stateDir}/.hermes/config.yaml
      chmod 0750 ${agentCfg.stateDir}/home 2>/dev/null || true

      for _d in cron sessions logs memories; do
      	if [ -d "${agentCfg.stateDir}/.hermes/$_d" ]; then
      		chmod 2770 "${agentCfg.stateDir}/.hermes/$_d" 2>/dev/null || true
      	fi
      done
    '';

    system.activationScripts."hermes-agent-cleanup-container" = lib.mkIf (!agentCfg.container.enable) (lib.stringAfter ["hermes-agent-fix-ownership"] ''
      if ${pkgs.podman}/bin/podman container exists hermes-agent 2>/dev/null; then
      	echo "hermes-agent: removing stale container from previous container mode..."
      	${pkgs.podman}/bin/podman stop -t 10 hermes-agent 2>/dev/null || true
      	${pkgs.podman}/bin/podman rm -f hermes-agent 2>/dev/null || true
      fi
    '');
  };
}
