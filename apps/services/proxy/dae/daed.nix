{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.services.proxy.daed;

  # dae needs geosite.dat + geoip.dat (v2ray format)
  daeAssets = pkgs.symlinkJoin {
    name = "dae-assets";
    paths = with pkgs; [v2ray-geoip v2ray-domain-list-community];
  };
in {
  options.apps.services.proxy.daed.enable = lib.mkEnableOption "daed (dae + web dashboard)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.daed];

    networking.firewall = {
      allowedTCPPorts = [7897 2023];
      allowedUDPPorts = [7897];
    };

    systemd.services.daed = {
      description = "daed — dae + API + web UI";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      conflicts = ["dae.service"];

      serviceConfig = {
        Type = "simple";
        User = "root";
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        Restart = "on-abnormal";
        StateDirectory = "daed";
        ExecStart = "${lib.getExe pkgs.daed} run -c /var/lib/daed";
        Environment = "DAE_LOCATION_ASSET=${daeAssets}/share/v2ray";
      };

      preStart = ''
        install -m 644 ${./config-daed.dae} /var/lib/daed/config.dae
      '';
    };
  };
}
