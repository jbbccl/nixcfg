{
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./driver.nix
    ./boot.nix
    ../common.nix
  ];

  services.upower.enable = lib.mkForce false;
 
  apps.services = {
    # monitoring.enable = true;
    remote.private = {
      vnc.enable = true;
      streaming.enable = true;
      streaming.moonlight = true;
      streaming.sunshine  = true;
      easytier ={
        enable = true;
        ipv4 = "10.144.144.1/24";
        # 入口机: 把这个节点通过 CF Tunnel 暴露成 wss 中继
        relayDomain = "app.bigdogbarks.top";
      };
    };
  };
  apps.game={
      misc.enable = true;
    };

  # networking.interfaces.enp7s0.macAddress = "0A:1B:2C:3D:4E:5F";
  desktop.winMgr.niri.outputs = {
    "eDP-1" = {
      mode = "3414x2134@60.0";
      scale = 1.5;
      position = {
        x = 1280;
        y = 0;
      };
    };
    "DP-1" = {mode = "1920x1080@120.000";};
  };
}
