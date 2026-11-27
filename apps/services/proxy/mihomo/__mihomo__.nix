{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.services.proxy.mihomo;
  airports = import ../airports.nix {inherit config lib;};
  template = builtins.readFile ./config.yaml;
in {
  options.apps.services.proxy.mihomo.enable = lib.mkEnableOption "mihomo proxy";

  config = lib.mkIf cfg.enable {
    sops.secrets = airports.secrets;

    sops.templates."mihomo-config.yaml" = {
      owner = "root";
      group = "root";
      mode = "640";
      content = airports.substitute template;
    };

    services.mihomo = {
      enable = true;
      configFile = config.sops.templates."mihomo-config.yaml".path;
      webui = pkgs.metacubexd;
      tunMode = true;
      # PROCESS-NAME 规则需要读取其他用户的 /proc
      processesInfo = true;
    };
    networking.firewall.trustedInterfaces = ["Meta"];

    systemd.services.mihomo = {
      # 不阻塞开机: 脱离 network-online 关键链, 上游连接失败会自动重试
      after = lib.mkForce ["network.target"];
      requires = lib.mkForce [];
    };
  };
}
