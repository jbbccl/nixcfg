{ config, lib, ... }:
lib.mkIf config.secrets.available {
  services.cloudflared = {
    enable = true;
    tunnels."sh-tunnel" = {
      credentialsFile = config.sops.secrets.cloudflared-sh-tunnel.path;
      ingress."sh.bigdogbarks.top" = "http://localhost:8082";
      default = "http_status:404";
    };
  };
}
