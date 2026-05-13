{ lib, config, self, ... }: let
  domain = "app.bigdogbarks.top";
  port   = 8082;
in {
  imports = [
    ./nginx.nix
    ./cloudflared.nix
  ];

  options.apps.services.ingress = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = domain;
      description = "ingress 域名";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = port;
      description = "nginx 监听端口";
    };
  };

  config = lib.mkIf (config.apps.services.ingress.enable && config.secrets.available) {
    sops.secrets.cloudflared-sh-tunnel = {
      sopsFile = "${self}/secrets/token.yaml";
    };
  };
}
