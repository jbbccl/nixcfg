{ config, lib, ... }:
let
	cfg = config.apps.services.ingress;
in
lib.mkIf (cfg.enable && config.secrets.available) {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."${cfg.domain}" = {
      listen = [ { addr = "127.0.0.1"; port = cfg.port; } ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:4000/";  # TODO: 改成实际后端端口
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
