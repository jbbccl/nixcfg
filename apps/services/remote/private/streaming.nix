{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.services.remote.private.streaming;
in {
  options.apps.services.remote.private.streaming.enable =
    lib.mkEnableOption "串流";
  options.apps.services.remote.private.streaming.sunshine =
    lib.mkEnableOption "sunshine";
  options.apps.services.remote.private.streaming.moonlight =
    lib.mkEnableOption "moonlight";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # 客户端
    (lib.mkIf cfg.moonlight {
      environment.systemPackages = [ pkgs.moonlight-qt ];
    })

    # 服务端
    (lib.mkIf cfg.sunshine {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        autoStart = false;
        # openFirewall = true;
      };

      networking.firewall.interfaces.easytier0 = {
        allowedTCPPorts = [ 47984 47989 47990 48010 ];
        allowedUDPPorts = [ 47998 47999 48000 48002 48010 ];
      };
    })
  ]);
}