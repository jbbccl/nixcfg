{ config, lib, ... }:
let
cfg = config.apps.services.ingress;
in
lib.mkIf (cfg.enable && config.secrets.available) {
  services.cloudflared = {
    enable = true;
    tunnels."sh-tunnel" = {
      credentialsFile = config.sops.secrets.cloudflared-sh-tunnel.path;
      ingress."${cfg.domain}" = "http://localhost:${toString cfg.port}";
      default = "http_status:404";
    };
  };
}
