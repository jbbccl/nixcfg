{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.services.ai.pi;
  piWrapped = pkgs.writeShellScriptBin "pi" ''
    set -a
    source ${config.sops.secrets.api-key-env.path}
    set +a
    exec ${pkgs.pi-coding-agent}/bin/pi "$@"
  '';
in {
  options.apps.services.ai.pi.enable = lib.mkEnableOption "pi-coding-agent CLI";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      piWrapped
    ];

    home-manager.users.${username} = {
      home.file.".pi/agent/settings.json" = {
        source = ./settings.json;
      };
    };
  };
}
