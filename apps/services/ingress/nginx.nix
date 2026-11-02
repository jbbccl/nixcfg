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

      # 裸 TCP 转发（nginx 默认 --with-stream）：外网口 -> 本机工具口
      # 反弹 shell: nc -lvnp 14444
      # RMI:        rmiregistry 11099 / JNDIExploit -i <本机外网 IP>
      streamConfig = ''
        server {
          listen 4444;
          proxy_pass 127.0.0.1:14444;
          proxy_timeout 1h;
        }
        server {
          listen 1099;
          proxy_pass 127.0.0.1:11099;
          proxy_timeout 1h;
        }
      '';

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

        # 无公网 IP：反向 shell 走 HTTP 信标（beacon.py 监听 127.0.0.1:8899，长轮询，别缓冲）
        locations."= /sh" = {
          proxyPass = "http://127.0.0.1:8899";
          extraConfig = ''
            proxy_read_timeout 60s;
            proxy_buffering off;
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

    networking.firewall.allowedTCPPorts = [4444 1099];
  }
