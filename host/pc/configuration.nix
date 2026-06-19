{...}: {
  imports = [
    ./hardware-configuration.nix
    ./driver.nix
    ./boot.nix
    ../common.nix
  ];

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
