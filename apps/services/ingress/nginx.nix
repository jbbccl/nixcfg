{
  config,
  lib,
  ...
}: let
  cfg = config.apps.services.ingress;
in
  lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts."${cfg.domain}" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = cfg.port;
          }
        ];

        # 后端 API
        locations."/api/" = {
          proxyPass = "http://127.0.0.1:8000/api/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        # 上传的图片
        locations."/uploads/" = {
          proxyPass = "http://127.0.0.1:8000/uploads/";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        # 前端 (Vite dev / 静态文件)
        locations."/" = {
          proxyPass = "http://127.0.0.1:5173/";
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
