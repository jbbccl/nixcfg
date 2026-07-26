{
  config,
  lib,
  ...
}: {
  imports = [
    ./base/__base__.nix
    ./dispMgr/__dispMgr__.nix
    ./winMgr/__winMgr__.nix
    ./shell/__shell__.nix
    ./input/__input__.nix
    ./term/__term__.nix
    ./fileMgr/__fileMgr__.nix
    ./browser/__browser__.nix
    # ./session/__session__.nix  # plasma/xfce full DE, conflicts with WM
  ];

  options.desktop.enable = lib.mkEnableOption "desktop environment (WM, bar, DM, theme, etc.)";

  config = lib.mkMerge [
    {desktop.enable = lib.mkDefault true;}
    (lib.mkIf config.desktop.enable {
      desktop = lib.mkDefault {
        base.theme = "manual";
        dispMgr.select = "noctalia-greeter";
        winMgr.list = [
          # "labwc"
          "niri"
        ];
        shell = {
          _noctalia.enable = true;

          # bar.list = [ "waybar" # "ironbar"];
          # bar.waybar.niriTaskbar = true;
          # wall.enable = true;
          # lock.select = "swaylock";
          # pwmenu.select = "wlogout";
          # notif.select = "mako";
          # launcher.select = "fuzzel";
        };
        input.select = "fcitx5";
        term.select = "kitty";
        fileMgr.list = ["dolphin" "thunar"];
      };
    })
  ];
}
