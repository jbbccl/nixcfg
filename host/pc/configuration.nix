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

  # pc 无电池: 压过 noctalia 的默认 true
  services.upower.enable = lib.mkForce false;

  # AMD (Ryzen 5 5600): Denuvo/LinUwUx 运行时按需启用
  # cpuid-fault-emulation 服务默认不自启, 玩前 systemctl start, 完事/开 VM 前 stop
  apps.game.linuwowo.enable = true;

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
