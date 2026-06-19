{
  lib,
  config,
  self,
  ...
}: let
  domain = "app.bigdogbarks.top";
  port = 8082;
  cfg = config.apps.services.ingress;
in {
  imports = [
    ./nginx.nix
    ./cloudflared.nix
  ];

  options.apps.services.ingress = {
    enable = lib.mkEnableOption "ingress services (cloudflared tunnel + nginx)";
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

  config = lib.mkIf cfg.enable {
    sops.secrets.cloudflared-sh-tunnel = {
      sopsFile = "${self}/secrets/token.yaml";
    };
  };
}
