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
